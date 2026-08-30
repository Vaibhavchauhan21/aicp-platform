# Deployment

## Development
Local Next.js app connected to a Supabase development project.

## Repository
GitHub is the source-control system. Use feature branches for meaningful work and small, descriptive commits.

## Production
- Vercel hosts Next.js.
- Supabase hosts database/auth/storage/realtime.
- Production secrets are configured through deployment environment variables.
- Do not commit `.env.local`.

## Environment
Typical variables will include public Supabase URL/key and server-only AI/provider secrets. Exact names are established during project initialization.

## Release checklist
1. Typecheck.
2. Lint.
3. Tests.
4. RLS/security checks.
5. Production migration review.
6. Seed/demo data separation.
7. Environment verification.
8. Build.
9. Smoke test critical user journey.
10. Monitor errors after deployment.
