# Modaf SaaS Conventions

## Source of Truth Hierarchy

When docs conflict, follow this priority:
1. `docs/project/*` (app-specific, highest priority)
2. Peak internal knowledge (`peaks/modaf-saas/knowledge/saas-internal/`)
3. Peak website knowledge (`peaks/modaf-saas/knowledge/saas-website/`)
4. Peak templates (lowest priority)

## Default Tech Stack

Unless the user specifies otherwise, assume:

| Layer | Default | Swap Guide |
|-------|---------|-----------|
| Frontend | Next.js (App Router) + TypeScript + Tailwind CSS | See escape hatches doc |
| UI Components | shadcn/ui (Radix) + Huge Icons | See escape hatches doc |
| Styling | tailwind-merge + class-variance-authority (CVA) | -- |
| Animation | Motion (framer-motion) | -- |
| Forms | react-hook-form + zod | -- |
| State | Tanstack Query (server) + nuqs (URL) + React Context (auth/theme) | -- |
| Auth | Auth.js (NextAuth v5) | See escape hatches doc |
| Database | PostgreSQL + Prisma ORM | See escape hatches doc |
| Billing | Stripe (Checkout + Customer Portal) | See escape hatches doc |
| Email | Resend + React Email | See escape hatches doc |
| Hosting | Vercel | See escape hatches doc |
| Testing | Vitest + Playwright + MSW + Faker | -- |

For swap guidance: `peaks/modaf-saas/knowledge/saas-internal/source/internal/23_escape_hatches.md`

## Global Build Rules

These apply to every build phase:

1. Do not start coding until project docs are generated and confirmed (Phases 0-2)
2. Build only v1 scope unless explicitly asked otherwise
3. Reuse shared patterns before creating new ones
4. Every page must be mobile responsive from the start
5. Every page must be keyboard-accessible from the start
6. Every data-driven view must handle four states: loading, empty, success, error
7. Permissions enforced at both routing and UI layers
8. Do not add features outside v1 scope
9. Run validation gates after every build phase
10. Read pattern snapshot before writing code in Phase 8+
11. Tag phase completions in git (`git tag phase-N-complete`)

## Phase Detection

When resuming work, detect the current phase:
1. No `docs/project/` → Phase 0
2. Incomplete `docs/project/` → Phase 2
3. Complete docs, no code → Phase 3
4. Code exists → Check for auth/onboarding/shell/dashboard/features/settings/admin/email/marketing to determine phase (4-14)

## Pattern Snapshot

From Phase 7 onward, a pattern snapshot (`docs/project/pattern_snapshot.md`) captures exact code conventions. All work in Phase 8+ MUST read the snapshot before writing code to prevent drift.

## File Numbering

File numbers indicate read/build order within each directory. Internal docs 01-28, phases 00-14.
