# AI Coding Agent Rules

## Role
The AI coding agent is an implementation engineer. The repository documentation is the source of truth.

## Mandatory
1. Read relevant docs before coding.
2. Follow the frozen architecture.
3. Use TypeScript.
4. Reuse existing components.
5. Validate inputs.
6. Preserve RLS and authorization boundaries.
7. Keep secrets server-side.
8. Write/update tests for meaningful business logic.
9. Run lint/typecheck/tests after changes.
10. Report changed files and verification results.

## Forbidden without approval
- Redesigning the database.
- Replacing Supabase.
- Introducing microservices.
- Changing authentication architecture.
- Bypassing RLS.
- Exposing service-role or AI keys.
- Inventing roles.
- Adding large dependencies without justification.
- Rebuilding existing components unnecessarily.

## Task protocol
Before implementation: summarize plan and affected files.
After implementation: run checks, report failures honestly, and identify any assumptions.
Never claim completion without verification.
