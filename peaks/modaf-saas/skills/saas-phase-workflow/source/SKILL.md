# Skill: SaaS Phase Workflow

## Purpose
Orchestrate the Modaf 15-phase SaaS build process. Detects current phase, loads the right framework files, and guides execution through each phase with validation gates.

## Trigger
- Starting a new SaaS project with Modaf
- Resuming a SaaS build session
- User asks to advance to the next phase

## Workflow

### Step 1: Detect Current Phase

Check project state to determine phase:

1. No `docs/project/` → **Phase 0** (Welcome)
2. `docs/project/` exists, fewer than 9 files → **Phase 2** (Project Docs)
3. All 9 project files, no source code → **Phase 3** (Architecture)
4. Source code exists → check for specific markers:
   - No Prisma schema → **Phase 4** (Foundation)
   - Schema but no auth → **Phase 5** (Auth)
   - Auth but no onboarding → **Phase 6** (Onboarding)
   - No app shell → **Phase 7** (Shell)
   - Shell but no dashboard → **Phase 8** (Dashboard)
   - Dashboard but features incomplete → **Phase 9** (Core Features)
   - Features but no settings/billing → **Phase 10** (Settings)
   - Settings but no admin → **Phase 11** (Admin)
   - Admin but no email templates → **Phase 12** (Email)
   - Emails but no marketing site → **Phase 13** (Marketing)
   - Marketing site exists → **Phase 14** (Polish)

### Step 2: Load Phase Context

Read the phase-specific index file:
`peaks/modaf-saas/knowledge/saas-internal/source/phases/phase_NN_[name].md`

This tells you exactly which framework files to read for this phase.

### Step 3: Execute Phase

1. Announce what you're building
2. Read only the framework files listed for this phase
3. Read `docs/project/*` for app-specific context
4. If Phase 8+, read `docs/project/pattern_snapshot.md` FIRST
5. Build the phase
6. Run validation gates (`peaks/modaf-saas/knowledge/saas-internal/source/internal/21_validation_gates.md`)
7. Run custom gates (`docs/project/custom_gates.md`) if they exist
8. Summarize what was completed
9. Ask user to review or continue

### Step 4: Phase Transition

After validation passes:
1. Tag in git: `git tag phase-N-complete`
2. If Phase 7, generate pattern snapshot at `docs/project/pattern_snapshot.md`
3. If Phase 8+, update pattern snapshot with new conventions
4. Update `active/active_context.md` with new phase
5. Announce next phase and what it involves

## Phase File Loading Reference

| Phase | Key Files to Read |
|-------|------------------|
| 0 | None (just welcome the user) |
| 1 | Templates (scan for structure) |
| 2 | Templates (for content generation) |
| 3 | internal/07, 06, 04, 09, 23 + project docs |
| 4 | internal/09, 21, 26, 27, 28 |
| 5 | internal/02 (Section A), 06, 28 |
| 6 | internal/02 (Section B), 28 |
| 7 | internal/01, 08, 10, 12, 15, 22 |
| 8 | pattern_snapshot, internal/03, 16, 13 |
| 9 | pattern_snapshot, internal/09, 08, 11, 12, 17 |
| 10 | internal/05 |
| 11 | internal/05 (admin sections) |
| 12 | internal/14 |
| 13 | ALL website/ docs |
| 14 | internal/17, 18, 19, 27, 28 + project edge cases/QA |

## Critical Rules
- Never skip validation gates between phases
- Always read pattern snapshot before code in Phase 8+
- Only one phase at a time unless using subagent dispatch (internal/20)
- Phase 0-2 must complete before any coding begins
