# RBAC and RLS

## Roles
Student, Industry, Academician, Institution, Admin.

## Access matrix

| Resource | Student | Industry | Academician | Institution | Admin |
|---|---|---|---|---|---|
| Own profile | CRUD | CRUD | CRUD | CRUD | CRUD |
| Opportunities | Read/apply | CRUD own | Read | Read | CRUD |
| Applications | Read/update own withdrawal | Read/update own postings | Read own | Read institution scope | CRUD |
| Assessments | Attempt/read own | Read aggregate only | Read aggregate | Read aggregate | CRUD |
| Resumes | CRUD own | Read applicants where authorized | No | No | Authorized support |
| Portfolio | CRUD own | Read public/applicant | Read public | Read institution scope | Authorized |
| Analytics | Own | Own company | Own/available | Institution scope | Global |

## RLS rules
- Users can read/update their own profile.
- Students can access only their own assessment attempts, skills, resumes, applications, and portfolio records.
- Industries can manage only opportunities belonging to their industry and applications to those opportunities.
- Institutions can access only institution-scoped student/analytics data according to membership.
- Academicians can manage their own profile and their permitted collaboration applications.
- Admin access is controlled by a trusted admin role/claim and server-side checks.

RLS policies must be tested explicitly. Service-role access is server-only and must never be used as a substitute for normal user authorization.
