# Security Checklist

- Supabase RLS enabled on all user-owned/sensitive tables.
- Authenticated routes protected.
- Server-only secrets stored in environment variables.
- Service-role key never shipped to browser.
- AI provider keys never shipped to browser.
- Zod/input validation at trust boundaries.
- Ownership checks on all mutations.
- Secure file upload policies and size/type restrictions.
- Avoid storing unnecessary sensitive personal data.
- Sanitize/escape user-generated content where rendered.
- Rate-limit authentication and expensive AI operations.
- Audit application-status and privileged changes.
- Verify production environment variables.
- Run dependency/security checks before deployment.
