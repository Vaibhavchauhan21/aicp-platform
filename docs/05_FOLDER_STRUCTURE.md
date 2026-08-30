# Folder Structure

```text
aicp/
├── app/
│   ├── (auth)/
│   ├── (dashboard)/
│   ├── api/
│   └── ...
├── components/
│   ├── ui/
│   ├── layout/
│   ├── charts/
│   └── domain/
├── lib/
│   ├── supabase/
│   ├── auth/
│   ├── services/
│   ├── ai/
│   ├── matching/
│   ├── validation/
│   └── utils/
├── types/
├── hooks/
├── supabase/
│   ├── migrations/
│   ├── seed.sql
│   └── config.toml
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── docs/
├── public/
├── .env.example
├── README.md
└── package.json
```

Do not create a microservice directory tree for MVP.
