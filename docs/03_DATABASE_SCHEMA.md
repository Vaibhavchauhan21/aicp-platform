# Database Schema

## Core identity
### profiles
`id uuid PK`, `full_name text`, `avatar_url text`, `phone text`, `location text`, `bio text`, `role app_role`, timestamps.

### students
`id uuid PK/FK profiles`, `institution_id uuid FK`, `degree text`, `branch text`, `graduation_year int`, `interests jsonb`.

### academicians
`id uuid PK/FK profiles`, `institution_id uuid FK`, `designation text`, `department text`, `specializations text[]`.

### industries
`id uuid PK`, `name text`, `description text`, `website text`, `industry_type text`, `verified boolean`.

### industry_members
`industry_id uuid FK`, `user_id uuid FK`, `member_role text`, composite PK.

### institutions
`id uuid PK`, `name text`, `type text`, `location text`, `verified boolean`.

### institution_members
`institution_id uuid FK`, `user_id uuid FK`, `member_role text`, composite PK.

## Skills and assessment
### skills
`id uuid PK`, `name text unique`, `category text`, `description text`.

### career_roles
`id uuid PK`, `title text`, `description text`, `active boolean`.

### role_skills
`role_id uuid FK`, `skill_id uuid FK`, `required_level numeric`, `importance numeric`, composite PK.

### assessments
`id uuid PK`, `title text`, `assessment_type text`, `active boolean`.

### assessment_questions
`id uuid PK`, `assessment_id uuid FK`, `question text`, `question_type text`, `options jsonb`, `skill_id uuid FK`, `difficulty numeric`.

### assessment_attempts
`id uuid PK`, `student_id uuid FK`, `assessment_id uuid FK`, `score numeric`, `started_at`, `completed_at`.

### assessment_answers
`id uuid PK`, `attempt_id uuid FK`, `question_id uuid FK`, `answer jsonb`, `score numeric`.

### student_skills
`student_id uuid FK`, `skill_id uuid FK`, `level numeric`, `source text`, `verified boolean`, timestamps, composite PK.

## Learning
### learning_programs
`id uuid PK`, `provider_name text`, `title text`, `description text`, `url text`, `duration_hours numeric`, `level text`, `certificate boolean`, `active boolean`.

### learning_skills
`learning_program_id uuid FK`, `skill_id uuid FK`, `target_level numeric`, composite PK.

## Opportunities
### opportunities
`id uuid PK`, `industry_id uuid FK`, `title text`, `type text`, `description text`, `location text`, `work_mode text`, `stipend numeric`, `salary_min numeric`, `salary_max numeric`, `eligibility jsonb`, `status text`, timestamps.

### opportunity_skills
`opportunity_id uuid FK`, `skill_id uuid FK`, `required_level numeric`, `importance numeric`, composite PK.

### applications
`id uuid PK`, `opportunity_id uuid FK`, `student_id uuid FK`, `resume_id uuid FK nullable`, `status text`, `match_score numeric`, timestamps. Unique `(opportunity_id, student_id)`.

### application_events
`id uuid PK`, `application_id uuid FK`, `from_status text`, `to_status text`, `changed_by uuid FK`, `notes text`, `created_at`.

## Resume/portfolio
### resumes
`id uuid PK`, `student_id uuid FK`, `title text`, `target_role_id uuid FK nullable`, `current_version_id uuid nullable`, timestamps.

### resume_versions
`id uuid PK`, `resume_id uuid FK`, `content jsonb`, `ats_score numeric`, `created_at`.

### portfolios
`id uuid PK`, `student_id uuid FK unique`, `slug text unique`, `visibility text`.

### portfolio_items
`id uuid PK`, `portfolio_id uuid FK`, `item_type text`, `title text`, `description text`, `metadata jsonb`, `verified boolean`.

## Collaboration and notifications
### collaboration_opportunities
`id uuid PK`, `created_by uuid FK`, `industry_id uuid FK nullable`, `institution_id uuid FK nullable`, `type text`, `title text`, `description text`, `status text`, timestamps.

### notifications
`id uuid PK`, `user_id uuid FK`, `type text`, `title text`, `message text`, `read_at timestamptz nullable`, `metadata jsonb`, `created_at`.

Use UUID primary keys, timestamptz timestamps, foreign-key indexes, and CHECK constraints/enums for controlled statuses. Exact SQL migrations will be generated during implementation from this schema.
