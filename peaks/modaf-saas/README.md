# Modaf SaaS Peak

A comprehensive SaaS application framework for Melted Peak. Guides the complete lifecycle of building a SaaS product -- from idea discovery through polish -- using a 15-phase interactive build process.

## What It Provides

- **2 Skills**: Phase workflow orchestrator, doctor mode diagnostics
- **2 Knowledge Packs**: Internal app docs (28 files), website/marketing docs (9 files)
- **9 Templates**: Project document templates (app idea, brief, features, flows, etc.)
- **4 Context Profiles**: Phase builds, discovery, architecture, marketing
- **Conventions**: Default tech stack, build rules, source of truth hierarchy

## The 15 Phases

| Phase | Name | What Happens |
|-------|------|-------------|
| 0 | Welcome | Collect app idea |
| 1 | Discovery | Interview to understand the product |
| 2 | Project Docs | Generate 9 app-specific documents |
| 3 | Architecture | Entities, routes, modules, build order |
| 4 | Foundation | Project setup, schema, utilities |
| 5 | Auth | Login, signup, session management |
| 6 | Onboarding | Multi-step onboarding, first value event |
| 7 | App Shell | Layout, navigation, responsive design |
| 8 | Dashboard | Main dashboard with selected archetype |
| 9 | Core Features | CRUD views, detail pages, forms |
| 10 | Settings & Billing | Stripe, profile, team management |
| 11 | Admin | Admin panel, user management |
| 12 | Email | Transactional email templates |
| 13 | Marketing | Public website, pricing, features pages |
| 14 | Polish | Edge cases, testing, performance, a11y |

## Default Tech Stack

Next.js (App Router) + TypeScript + Tailwind + shadcn/ui + Prisma + PostgreSQL + Auth.js + Stripe + Resend + Vercel

See `conventions.md` for the full default stack and swap guidance.

## Source

Imported from [github.com/mosnin/LoxSammy](https://github.com/mosnin/LoxSammy)
