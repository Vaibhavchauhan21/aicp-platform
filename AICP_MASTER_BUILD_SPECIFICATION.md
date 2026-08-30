# AICP Master Build Specification

**Project:** Academia–Industry Collaboration Portal (AICP)  
**Purpose:** Smart India Hackathon implementation blueprint  
**Status:** Architecture and MVP scope frozen before coding.

## 1. Source of truth
This document consolidates the decisions made during Steps 1–8. It is implementation-ready and is the parent specification for the focused documents in `docs/`.

## 2. Problem
AICP addresses the gap between academic skills and industry expectations by connecting students, industries, academicians, and institutions around skill development, internships, placements, learning, mentorship, and collaboration.

## 3. Core product loop
Student profile → assessment → skill profile → skill-gap analysis → learning/career recommendations → internship/job matching → AI resume → application → recruiter workflow → institution analytics.

## 4. Roles
- Student
- Industry
- Academician
- Institution
- Admin

## 5. MVP
P0 includes authentication, profiles, skill assessment, skill profiling, skill-gap analysis, career and learning recommendations, internship/job marketplace, matching, applications, AI resume builder/analyzer, portfolio, academician opportunities, industry dashboard, institution analytics, collaboration, notifications, admin, and search.

P1 includes AI interview preparation, career roadmap, internship readiness, and portfolio AI.

P2/P3 are post-hackathon extensions such as advanced RAG, AI mentor, extensive integrations, workforce forecasting, and national-scale intelligence.

## 6. Technology baseline
- Next.js + TypeScript
- Tailwind CSS + shadcn/ui + Lucide
- Supabase PostgreSQL, Auth, Storage, Realtime
- Zod
- Recharts
- LLM API through a server-side AI gateway
- Vercel deployment

## 7. Architecture principles
- Keep a modular monolith for MVP.
- Supabase is the backend platform.
- Never expose service-role credentials client-side.
- Enforce authorization with Supabase RLS.
- AI calls occur server-side.
- Validate external/user input with schemas.
- Prefer reusable components and typed service boundaries.
- Do not redesign the frozen architecture without explicit approval.

## 8. Primary student experience
1. Register/login.
2. Complete profile.
3. Take technical, soft-skill, and aptitude assessments.
4. Receive skill profile and readiness score.
5. Select a target career.
6. View skill gaps.
7. Receive learning recommendations.
8. Discover matched internships/jobs.
9. Generate/analyze an AI resume.
10. Apply.
11. Track status.
12. Maintain a verified digital portfolio.

## 9. Industry experience
Company profile → create opportunities → define eligibility/skills → receive applications → inspect compatibility → shortlist → update recruitment status.

## 10. Academician experience
Profile → discover/apply to faculty internships, industrial training, FDPs, consultancy, research, mentorship, guest lectures, and related collaboration opportunities.

## 11. Institution experience
Institution dashboard → monitor students, skills, internships, placements, industry engagement, and skill-demand trends.

## 12. SIH demo
The preferred demo follows one student's complete journey from assessment to skill gap to learning to matched opportunity to AI resume to application, then switches to recruiter and institution views.

## 13. Definition of done
AICP MVP is done only when the critical journey works end-to-end with real persisted database data, authentication, authorization/RLS, AI integration where specified, application state changes, and meaningful institution/recruiter dashboards.

## 14. Detailed specifications
See the 18 focused documents in `docs/`.
