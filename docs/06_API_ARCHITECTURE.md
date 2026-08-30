# API / Service Architecture

Prefer server services and route handlers where a network boundary is needed.

## Domains
- `/api/profile`
- `/api/assessments`
- `/api/skills`
- `/api/careers`
- `/api/learning`
- `/api/opportunities`
- `/api/applications`
- `/api/resumes`
- `/api/portfolio`
- `/api/collaboration`
- `/api/notifications`
- `/api/analytics`
- `/api/ai/*`

## AI endpoints
- `POST /api/ai/resume/generate`
- `POST /api/ai/resume/analyze`
- `POST /api/ai/career/recommend`
- `POST /api/ai/skills/analyze`
- `POST /api/ai/match/explain`

Validate input with Zod. Authenticate every protected request. Never trust client-supplied role or ownership fields.

## Service examples
`assessmentService`, `skillService`, `matchingService`, `applicationService`, `resumeService`, `analyticsService`, `notificationService`.
