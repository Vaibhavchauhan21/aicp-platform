# Database ER Diagram

The canonical ERD is conceptually:

```text
auth.users
   |
profiles
   |--------------------+
   |                    |
students            academicians
   |                    |
student_skills      faculty_opportunities
   |
assessments
   |
assessment_attempts
   |
skill_scores
   |
career_roles ---- role_skills ---- skills
   |
learning_programs ---- learning_skills
   |
opportunities ---- opportunity_skills
   |
applications ---- application_events
   |
resumes ---- resume_versions
   |
portfolios ---- portfolio_items
   |
notifications

institutions ---- institution_members
industries ---- industry_members
collaboration_opportunities
```

Foreign keys, cardinalities, indexes, and RLS details are defined in `03_DATABASE_SCHEMA.md` and `07_RBAC_RLS.md`.

The implementation should use normalized relational data for authoritative records and derived/materialized data only where performance requires it.
