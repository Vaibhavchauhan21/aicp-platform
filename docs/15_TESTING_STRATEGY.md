# Testing Strategy

## Unit
Test matching calculations, eligibility rules, validation, formatting, and deterministic skill-gap logic.

## Integration
Test services against a test/controlled Supabase environment where practical.

## RLS
Test each role against allowed and denied operations.

## E2E
Critical flow: signup/login → profile → assessment → skill gap → opportunity → resume → application → recruiter shortlist → institution analytics.

## AI
Validate schema-conformity, no fabricated resume facts, fallback behavior, prompt/input limits, and deterministic business rules.

## Quality gates
Typecheck, lint, unit tests, integration tests, and critical E2E tests must pass before release.
