-- ============================================================
-- AICP - Initial Database Schema
-- Migration: 20260830160000_initial_schema.sql
--
-- Source of truth:
--   docs/02_DATABASE_ERD.md
--   docs/03_DATABASE_SCHEMA.md
--   docs/07_RBAC_RLS.md
-- ============================================================

-- ------------------------------------------------------------
-- Extensions
-- ------------------------------------------------------------

create extension if not exists pgcrypto;


-- ------------------------------------------------------------
-- Helper function: automatically update updated_at
-- ------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;


-- ------------------------------------------------------------
-- Application roles
-- ------------------------------------------------------------

create type public.app_role as enum (
  'student',
  'industry',
  'academician',
  'institution',
  'admin'
);


-- ------------------------------------------------------------
-- Controlled statuses / values
-- ------------------------------------------------------------

create type public.opportunity_status as enum (
  'draft',
  'published',
  'closed',
  'archived'
);

create type public.application_status as enum (
  'submitted',
  'under_review',
  'shortlisted',
  'interview',
  'selected',
  'rejected',
  'withdrawn'
);

create type public.collaboration_status as enum (
  'draft',
  'open',
  'in_progress',
  'completed',
  'cancelled'
);

create type public.portfolio_visibility as enum (
  'private',
  'public'
);


-- ============================================================
-- CORE IDENTITY
-- ============================================================

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  avatar_url text,
  phone text,
  location text,
  bio text,
  role public.app_role not null default 'student',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.institutions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type text,
  location text,
  verified boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.industries (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  website text,
  industry_type text,
  verified boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.students (
  id uuid primary key references public.profiles(id) on delete cascade,
  institution_id uuid references public.institutions(id) on delete set null,
  degree text,
  branch text,
  graduation_year int,
  interests jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.academicians (
  id uuid primary key references public.profiles(id) on delete cascade,
  institution_id uuid references public.institutions(id) on delete set null,
  designation text,
  department text,
  specializations text[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.industry_members (
  industry_id uuid not null references public.industries(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  member_role text not null,
  primary key (industry_id, user_id)
);


create table public.institution_members (
  institution_id uuid not null references public.institutions(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  member_role text not null,
  primary key (institution_id, user_id)
);


-- ============================================================
-- SKILLS AND ASSESSMENT
-- ============================================================

create table public.skills (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  category text,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.career_roles (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.role_skills (
  role_id uuid not null references public.career_roles(id) on delete cascade,
  skill_id uuid not null references public.skills(id) on delete cascade,
  required_level numeric not null,
  importance numeric not null,
  primary key (role_id, skill_id),
  check (required_level >= 0),
  check (importance >= 0)
);


create table public.assessments (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  assessment_type text not null,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.assessment_questions (
  id uuid primary key default gen_random_uuid(),
  assessment_id uuid not null references public.assessments(id) on delete cascade,
  question text not null,
  question_type text not null,
  options jsonb not null default '[]'::jsonb,
  skill_id uuid references public.skills(id) on delete set null,
  difficulty numeric,
  created_at timestamptz not null default now(),
  check (difficulty is null or difficulty >= 0)
);


create table public.assessment_attempts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  assessment_id uuid not null references public.assessments(id) on delete cascade,
  score numeric,
  started_at timestamptz not null default now(),
  completed_at timestamptz,
  check (score is null or score >= 0)
);


create table public.assessment_answers (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references public.assessment_attempts(id) on delete cascade,
  question_id uuid not null references public.assessment_questions(id) on delete cascade,
  answer jsonb,
  score numeric,
  check (score is null or score >= 0)
);


create table public.student_skills (
  student_id uuid not null references public.students(id) on delete cascade,
  skill_id uuid not null references public.skills(id) on delete cascade,
  level numeric not null,
  source text not null,
  verified boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (student_id, skill_id),
  check (level >= 0)
);


-- ============================================================
-- LEARNING
-- ============================================================

create table public.learning_programs (
  id uuid primary key default gen_random_uuid(),
  provider_name text not null,
  title text not null,
  description text,
  url text,
  duration_hours numeric,
  level text,
  certificate boolean not null default false,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (duration_hours is null or duration_hours >= 0)
);


create table public.learning_skills (
  learning_program_id uuid not null references public.learning_programs(id) on delete cascade,
  skill_id uuid not null references public.skills(id) on delete cascade,
  target_level numeric not null,
  primary key (learning_program_id, skill_id),
  check (target_level >= 0)
);


-- ============================================================
-- OPPORTUNITIES
-- ============================================================

create table public.opportunities (
  id uuid primary key default gen_random_uuid(),
  industry_id uuid not null references public.industries(id) on delete cascade,
  title text not null,
  type text not null,
  description text,
  location text,
  work_mode text,
  stipend numeric,
  salary_min numeric,
  salary_max numeric,
  eligibility jsonb not null default '{}'::jsonb,
  status public.opportunity_status not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (stipend is null or stipend >= 0),
  check (salary_min is null or salary_min >= 0),
  check (salary_max is null or salary_max >= 0),
  check (
    salary_min is null
    or salary_max is null
    or salary_max >= salary_min
  )
);


create table public.opportunity_skills (
  opportunity_id uuid not null references public.opportunities(id) on delete cascade,
  skill_id uuid not null references public.skills(id) on delete cascade,
  required_level numeric not null,
  importance numeric not null,
  primary key (opportunity_id, skill_id),
  check (required_level >= 0),
  check (importance >= 0)
);


create table public.resumes (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.students(id) on delete cascade,
  title text not null,
  target_role_id uuid references public.career_roles(id) on delete set null,
  current_version_id uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.applications (
  id uuid primary key default gen_random_uuid(),
  opportunity_id uuid not null references public.opportunities(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  resume_id uuid references public.resumes(id) on delete set null,
  status public.application_status not null default 'submitted',
  match_score numeric,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (opportunity_id, student_id),
  check (match_score is null or (match_score >= 0 and match_score <= 100))
);


create table public.application_events (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.applications(id) on delete cascade,
  from_status text,
  to_status text not null,
  changed_by uuid not null references public.profiles(id) on delete restrict,
  notes text,
  created_at timestamptz not null default now()
);


-- ============================================================
-- RESUME / PORTFOLIO
-- ============================================================

create table public.resume_versions (
  id uuid primary key default gen_random_uuid(),
  resume_id uuid not null references public.resumes(id) on delete cascade,
  content jsonb not null,
  ats_score numeric,
  created_at timestamptz not null default now(),
  check (ats_score is null or (ats_score >= 0 and ats_score <= 100))
);


alter table public.resumes
  add constraint resumes_current_version_fk
  foreign key (current_version_id)
  references public.resume_versions(id)
  on delete set null;


create table public.portfolios (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null unique references public.students(id) on delete cascade,
  slug text not null unique,
  visibility public.portfolio_visibility not null default 'private',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.portfolio_items (
  id uuid primary key default gen_random_uuid(),
  portfolio_id uuid not null references public.portfolios(id) on delete cascade,
  item_type text not null,
  title text not null,
  description text,
  metadata jsonb not null default '{}'::jsonb,
  verified boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


-- ============================================================
-- COLLABORATION / NOTIFICATIONS
-- ============================================================

create table public.collaboration_opportunities (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references public.profiles(id) on delete restrict,
  industry_id uuid references public.industries(id) on delete set null,
  institution_id uuid references public.institutions(id) on delete set null,
  type text not null,
  title text not null,
  description text,
  status public.collaboration_status not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null,
  title text not null,
  message text not null,
  read_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);


-- ============================================================
-- INDEXES
-- ============================================================

create index idx_students_institution_id
  on public.students(institution_id);

create index idx_academicians_institution_id
  on public.academicians(institution_id);

create index idx_industry_members_user_id
  on public.industry_members(user_id);

create index idx_institution_members_user_id
  on public.institution_members(user_id);

create index idx_role_skills_skill_id
  on public.role_skills(skill_id);

create index idx_assessment_questions_assessment_id
  on public.assessment_questions(assessment_id);

create index idx_assessment_questions_skill_id
  on public.assessment_questions(skill_id);

create index idx_assessment_attempts_student_id
  on public.assessment_attempts(student_id);

create index idx_assessment_attempts_assessment_id
  on public.assessment_attempts(assessment_id);

create index idx_assessment_answers_attempt_id
  on public.assessment_answers(attempt_id);

create index idx_assessment_answers_question_id
  on public.assessment_answers(question_id);

create index idx_student_skills_skill_id
  on public.student_skills(skill_id);

create index idx_learning_skills_skill_id
  on public.learning_skills(skill_id);

create index idx_opportunities_industry_id
  on public.opportunities(industry_id);

create index idx_opportunities_status
  on public.opportunities(status);

create index idx_opportunity_skills_skill_id
  on public.opportunity_skills(skill_id);

create index idx_applications_student_id
  on public.applications(student_id);

create index idx_applications_opportunity_id
  on public.applications(opportunity_id);

create index idx_applications_status
  on public.applications(status);

create index idx_application_events_application_id
  on public.application_events(application_id);

create index idx_application_events_changed_by
  on public.application_events(changed_by);

create index idx_resumes_student_id
  on public.resumes(student_id);

create index idx_resume_versions_resume_id
  on public.resume_versions(resume_id);

create index idx_portfolio_items_portfolio_id
  on public.portfolio_items(portfolio_id);

create index idx_collaboration_opportunities_created_by
  on public.collaboration_opportunities(created_by);

create index idx_collaboration_opportunities_industry_id
  on public.collaboration_opportunities(industry_id);

create index idx_collaboration_opportunities_institution_id
  on public.collaboration_opportunities(institution_id);

create index idx_notifications_user_id
  on public.notifications(user_id);

create index idx_notifications_read_at
  on public.notifications(read_at);


-- ============================================================
-- UPDATED_AT TRIGGERS
-- ============================================================

create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

create trigger institutions_set_updated_at
before update on public.institutions
for each row execute function public.set_updated_at();

create trigger industries_set_updated_at
before update on public.industries
for each row execute function public.set_updated_at();

create trigger students_set_updated_at
before update on public.students
for each row execute function public.set_updated_at();

create trigger academicians_set_updated_at
before update on public.academicians
for each row execute function public.set_updated_at();

create trigger skills_set_updated_at
before update on public.skills
for each row execute function public.set_updated_at();

create trigger career_roles_set_updated_at
before update on public.career_roles
for each row execute function public.set_updated_at();

create trigger assessments_set_updated_at
before update on public.assessments
for each row execute function public.set_updated_at();

create trigger student_skills_set_updated_at
before update on public.student_skills
for each row execute function public.set_updated_at();

create trigger learning_programs_set_updated_at
before update on public.learning_programs
for each row execute function public.set_updated_at();

create trigger opportunities_set_updated_at
before update on public.opportunities
for each row execute function public.set_updated_at();

create trigger applications_set_updated_at
before update on public.applications
for each row execute function public.set_updated_at();

create trigger resumes_set_updated_at
before update on public.resumes
for each row execute function public.set_updated_at();

create trigger portfolios_set_updated_at
before update on public.portfolios
for each row execute function public.set_updated_at();

create trigger portfolio_items_set_updated_at
before update on public.portfolio_items
for each row execute function public.set_updated_at();

create trigger collaboration_opportunities_set_updated_at
before update on public.collaboration_opportunities
for each row execute function public.set_updated_at();


-- ============================================================
-- RLS
-- ============================================================

alter table public.profiles enable row level security;
alter table public.students enable row level security;
alter table public.academicians enable row level security;
alter table public.industries enable row level security;
alter table public.industry_members enable row level security;
alter table public.institutions enable row level security;
alter table public.institution_members enable row level security;
alter table public.skills enable row level security;
alter table public.career_roles enable row level security;
alter table public.role_skills enable row level security;
alter table public.assessments enable row level security;
alter table public.assessment_questions enable row level security;
alter table public.assessment_attempts enable row level security;
alter table public.assessment_answers enable row level security;
alter table public.student_skills enable row level security;
alter table public.learning_programs enable row level security;
alter table public.learning_skills enable row level security;
alter table public.opportunities enable row level security;
alter table public.opportunity_skills enable row level security;
alter table public.applications enable row level security;
alter table public.application_events enable row level security;
alter table public.resumes enable row level security;
alter table public.resume_versions enable row level security;
alter table public.portfolios enable row level security;
alter table public.portfolio_items enable row level security;
alter table public.collaboration_opportunities enable row level security;
alter table public.notifications enable row level security;


-- ------------------------------------------------------------
-- Security helper functions
-- ------------------------------------------------------------

create or replace function public.current_user_role()
returns public.app_role
language sql
stable
security definer
set search_path = public
as $$
  select role
  from public.profiles
  where id = auth.uid()
  limit 1;
$$;


create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select
    coalesce(
      (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin',
      false
    )
    or coalesce(public.current_user_role() = 'admin', false);
$$;


create or replace function public.is_industry_member(target_industry_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.industry_members
    where industry_id = target_industry_id
      and user_id = auth.uid()
  );
$$;


create or replace function public.is_institution_member(target_institution_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.institution_members
    where institution_id = target_institution_id
      and user_id = auth.uid()
  );
$$;


-- ============================================================
-- PROFILES
-- ============================================================

create policy profiles_select_own
on public.profiles
for select
to authenticated
using (id = auth.uid() or public.is_admin());

create policy profiles_insert_own
on public.profiles
for insert
to authenticated
with check (id = auth.uid() or public.is_admin());

create policy profiles_update_own
on public.profiles
for update
to authenticated
using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

create policy profiles_delete_own
on public.profiles
for delete
to authenticated
using (id = auth.uid() or public.is_admin());


-- ============================================================
-- STUDENTS
-- ============================================================

create policy students_select_own
on public.students
for select
to authenticated
using (
  id = auth.uid()
  or public.is_admin()
  or public.is_institution_member(institution_id)
);

create policy students_insert_own
on public.students
for insert
to authenticated
with check (
  id = auth.uid()
  or public.is_admin()
);

create policy students_update_own
on public.students
for update
to authenticated
using (
  id = auth.uid()
  or public.is_admin()
)
with check (
  id = auth.uid()
  or public.is_admin()
);

create policy students_delete_own
on public.students
for delete
to authenticated
using (
  id = auth.uid()
  or public.is_admin()
);


-- ============================================================
-- ACADEMICIANS
-- ============================================================

create policy academicians_select
on public.academicians
for select
to authenticated
using (
  id = auth.uid()
  or public.is_admin()
  or public.is_institution_member(institution_id)
);

create policy academicians_insert
on public.academicians
for insert
to authenticated
with check (
  id = auth.uid()
  or public.is_admin()
);

create policy academicians_update
on public.academicians
for update
to authenticated
using (
  id = auth.uid()
  or public.is_admin()
)
with check (
  id = auth.uid()
  or public.is_admin()
);

create policy academicians_delete
on public.academicians
for delete
to authenticated
using (
  id = auth.uid()
  or public.is_admin()
);


-- ============================================================
-- INDUSTRIES / MEMBERS
-- ============================================================

create policy industries_read_authenticated
on public.industries
for select
to authenticated
using (true);

create policy industries_admin
on public.industries
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy industry_members_read
on public.industry_members
for select
to authenticated
using (
  user_id = auth.uid()
  or public.is_industry_member(industry_id)
  or public.is_admin()
);

create policy industry_members_admin
on public.industry_members
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());


-- ============================================================
-- INSTITUTIONS / MEMBERS
-- ============================================================

create policy institutions_read_authenticated
on public.institutions
for select
to authenticated
using (true);

create policy institutions_admin
on public.institutions
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy institution_members_read
on public.institution_members
for select
to authenticated
using (
  user_id = auth.uid()
  or public.is_institution_member(institution_id)
  or public.is_admin()
);

create policy institution_members_admin
on public.institution_members
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());


-- ============================================================
-- SKILLS / CAREER ROLES
-- ============================================================

create policy skills_read_authenticated
on public.skills
for select
to authenticated
using (true);

create policy skills_admin
on public.skills
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy career_roles_read_authenticated
on public.career_roles
for select
to authenticated
using (active = true or public.is_admin());

create policy career_roles_admin
on public.career_roles
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy role_skills_read_authenticated
on public.role_skills
for select
to authenticated
using (true);

create policy role_skills_admin
on public.role_skills
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());


-- ============================================================
-- ASSESSMENTS
-- ============================================================

create policy assessments_read_active
on public.assessments
for select
to authenticated
using (active = true or public.is_admin());

create policy assessments_admin
on public.assessments
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy assessment_questions_read
on public.assessment_questions
for select
to authenticated
using (
  exists (
    select 1
    from public.assessments a
    where a.id = assessment_id
      and (a.active = true or public.is_admin())
  )
);

create policy assessment_questions_admin
on public.assessment_questions
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());


-- ============================================================
-- ASSESSMENT ATTEMPTS / ANSWERS
-- ============================================================

create policy assessment_attempts_own
on public.assessment_attempts
for all
to authenticated
using (
  student_id = auth.uid()
  or public.is_admin()
)
with check (
  student_id = auth.uid()
  or public.is_admin()
);

create policy assessment_answers_own
on public.assessment_answers
for all
to authenticated
using (
  exists (
    select 1
    from public.assessment_attempts aa
    where aa.id = attempt_id
      and (
        aa.student_id = auth.uid()
        or public.is_admin()
      )
  )
)
with check (
  exists (
    select 1
    from public.assessment_attempts aa
    where aa.id = attempt_id
      and (
        aa.student_id = auth.uid()
        or public.is_admin()
      )
  )
);


-- ============================================================
-- STUDENT SKILLS
-- ============================================================

create policy student_skills_own
on public.student_skills
for all
to authenticated
using (
  student_id = auth.uid()
  or public.is_admin()
)
with check (
  student_id = auth.uid()
  or public.is_admin()
);


-- ============================================================
-- LEARNING PROGRAMS
-- ============================================================

create policy learning_programs_read_active
on public.learning_programs
for select
to authenticated
using (active = true or public.is_admin());

create policy learning_programs_admin
on public.learning_programs
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy learning_skills_read
on public.learning_skills
for select
to authenticated
using (true);

create policy learning_skills_admin
on public.learning_skills
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());


-- ============================================================
-- OPPORTUNITIES
-- ============================================================

create policy opportunities_student_read
on public.opportunities
for select
to authenticated
using (
  status = 'published'
  or public.is_admin()
  or public.is_industry_member(industry_id)
);

create policy opportunities_industry_manage
on public.opportunities
for all
to authenticated
using (
  public.is_industry_member(industry_id)
  or public.is_admin()
)
with check (
  public.is_industry_member(industry_id)
  or public.is_admin()
);

create policy opportunity_skills_read
on public.opportunity_skills
for select
to authenticated
using (
  exists (
    select 1
    from public.opportunities o
    where o.id = opportunity_id
      and (
        o.status = 'published'
        or public.is_industry_member(o.industry_id)
        or public.is_admin()
      )
  )
);

create policy opportunity_skills_industry_manage
on public.opportunity_skills
for all
to authenticated
using (
  exists (
    select 1
    from public.opportunities o
    where o.id = opportunity_id
      and (
        public.is_industry_member(o.industry_id)
        or public.is_admin()
      )
  )
)
with check (
  exists (
    select 1
    from public.opportunities o
    where o.id = opportunity_id
      and (
        public.is_industry_member(o.industry_id)
        or public.is_admin()
      )
  )
);


-- ============================================================
-- APPLICATIONS
-- ============================================================

create policy applications_student_own
on public.applications
for select
to authenticated
using (
  student_id = auth.uid()
  or public.is_admin()
  or exists (
    select 1
    from public.opportunities o
    where o.id = opportunity_id
      and public.is_industry_member(o.industry_id)
  )
);

create policy applications_student_insert
on public.applications
for insert
to authenticated
with check (
  student_id = auth.uid()
  and exists (
    select 1
    from public.opportunities o
    where o.id = opportunity_id
      and o.status = 'published'
  )
);

create policy applications_student_update
on public.applications
for update
to authenticated
using (
  student_id = auth.uid()
  or public.is_admin()
  or exists (
    select 1
    from public.opportunities o
    where o.id = opportunity_id
      and public.is_industry_member(o.industry_id)
  )
)
with check (
  student_id = auth.uid()
  or public.is_admin()
  or exists (
    select 1
    from public.opportunities o
    where o.id = opportunity_id
      and public.is_industry_member(o.industry_id)
  )
);

create policy applications_admin_delete
on public.applications
for delete
to authenticated
using (public.is_admin());


-- ============================================================
-- APPLICATION EVENTS
-- ============================================================

create policy application_events_authorized_read
on public.application_events
for select
to authenticated
using (
  public.is_admin()
  or exists (
    select 1
    from public.applications ap
    where ap.id = application_id
      and (
        ap.student_id = auth.uid()
        or exists (
          select 1
          from public.opportunities o
          where o.id = ap.opportunity_id
            and public.is_industry_member(o.industry_id)
        )
      )
  )
);

create policy application_events_authorized_insert
on public.application_events
for insert
to authenticated
with check (
  public.is_admin()
  or changed_by = auth.uid()
);


-- ============================================================
-- RESUMES / RESUME VERSIONS
-- ============================================================

create policy resumes_own
on public.resumes
for all
to authenticated
using (
  student_id = auth.uid()
  or public.is_admin()
)
with check (
  student_id = auth.uid()
  or public.is_admin()
);

create policy resume_versions_own
on public.resume_versions
for all
to authenticated
using (
  exists (
    select 1
    from public.resumes r
    where r.id = resume_id
      and (
        r.student_id = auth.uid()
        or public.is_admin()
      )
  )
)
with check (
  exists (
    select 1
    from public.resumes r
    where r.id = resume_id
      and (
        r.student_id = auth.uid()
        or public.is_admin()
      )
  )
);


-- ============================================================
-- PORTFOLIOS
-- ============================================================

create policy portfolios_owner
on public.portfolios
for all
to authenticated
using (
  student_id = auth.uid()
  or public.is_admin()
)
with check (
  student_id = auth.uid()
  or public.is_admin()
);

create policy portfolios_public
on public.portfolios
for select
to anon, authenticated
using (visibility = 'public');


create policy portfolio_items_owner
on public.portfolio_items
for all
to authenticated
using (
  public.is_admin()
  or exists (
    select 1
    from public.portfolios p
    where p.id = portfolio_id
      and p.student_id = auth.uid()
  )
)
with check (
  public.is_admin()
  or exists (
    select 1
    from public.portfolios p
    where p.id = portfolio_id
      and p.student_id = auth.uid()
  )
);

create policy portfolio_items_public
on public.portfolio_items
for select
to anon, authenticated
using (
  exists (
    select 1
    from public.portfolios p
    where p.id = portfolio_id
      and p.visibility = 'public'
  )
);


-- ============================================================
-- COLLABORATION
-- ============================================================

create policy collaboration_read
on public.collaboration_opportunities
for select
to authenticated
using (
  public.is_admin()
  or created_by = auth.uid()
  or (
    industry_id is not null
    and public.is_industry_member(industry_id)
  )
  or (
    institution_id is not null
    and public.is_institution_member(institution_id)
  )
);

create policy collaboration_create
on public.collaboration_opportunities
for insert
to authenticated
with check (
  created_by = auth.uid()
  or public.is_admin()
);

create policy collaboration_update
on public.collaboration_opportunities
for update
to authenticated
using (
  created_by = auth.uid()
  or public.is_admin()
)
with check (
  created_by = auth.uid()
  or public.is_admin()
);

create policy collaboration_delete
on public.collaboration_opportunities
for delete
to authenticated
using (
  created_by = auth.uid()
  or public.is_admin()
);


-- ============================================================
-- NOTIFICATIONS
-- ============================================================

create policy notifications_own
on public.notifications
for select
to authenticated
using (
  user_id = auth.uid()
  or public.is_admin()
);

create policy notifications_update_own
on public.notifications
for update
to authenticated
using (
  user_id = auth.uid()
  or public.is_admin()
)
with check (
  user_id = auth.uid()
  or public.is_admin()
);

create policy notifications_admin_insert
on public.notifications
for insert
to authenticated
with check (public.is_admin());

create policy notifications_admin_delete
on public.notifications
for delete
to authenticated
using (public.is_admin());