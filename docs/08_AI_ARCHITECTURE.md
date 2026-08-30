# AI Architecture

## Principle
AI augments deterministic application logic; it does not replace authorization, eligibility rules, or authoritative records.

## AI gateway
A server-side module receives a typed task, validates input, selects a model, requests structured output, validates the output, logs safe metadata, and returns a typed result.

## AI modules
### Skill AI
Analyzes assessment/profile evidence and explains strengths/gaps.

### Career AI
Ranks compatible career roles using deterministic skill scores plus optional LLM explanation.

### Learning AI
Maps gaps to learning programs.

### Matching AI
A deterministic match score should be calculated from skills/eligibility; AI may explain the score.

### Resume AI
Generates structured resume sections from verified profile data and analyzes ATS/role alignment.

## Guardrails
- No invented skills, degrees, certifications, or employment.
- Use only user-provided/verified source data for factual resume claims.
- Return structured JSON validated by Zod.
- Keep secrets server-side.
- Rate-limit expensive calls.
- Log request metadata without sensitive prompt content where possible.
- Provide fallback behavior if AI is unavailable.

## Suggested matching formula
Start with deterministic weighted scoring:
`match = weighted_skill_coverage + eligibility_score + career_alignment + optional project_alignment`.
Keep weights configurable rather than hard-coded throughout the UI.
