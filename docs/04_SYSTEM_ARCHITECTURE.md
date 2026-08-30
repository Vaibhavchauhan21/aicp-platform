# System Architecture

## Architecture style
A modular monolith for MVP.

```text
Browser
  ↓
Next.js App Router
  ↓
Server Actions / Route Handlers / Server Services
  ↓
Supabase
 ├─ PostgreSQL
 ├─ Auth
 ├─ Storage
 └─ Realtime

Server-side AI Gateway
  ↓
LLM Provider
```

## Rules
- UI components must not contain privileged database credentials.
- Business logic should live in typed service modules.
- AI requests must pass through server-side code.
- Supabase RLS is the final authorization boundary.
- External integrations are isolated behind adapters.
