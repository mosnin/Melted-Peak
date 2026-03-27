# Protocol Cheat Sheet

Quick reference for all protocols. Load this instead of individual protocol docs when context is tight. For full details, read the individual protocol file.

---

## Change Control (23)
1. Write plan to `active/change_plan.md`: files, changes, risks, rollback
2. Get user confirmation
3. Execute in order. Log deviations.
4. Run validation. Close plan.

## Regression Prevention (25)
1. Read `active/regression_checklist.md` -- is this area listed?
2. Check what imports/calls the changed files
3. Run `active/validation_plan.md`
4. If regression found: STOP, log to `memory/known_issues.md`, do not fix inline
5. Add new sensitive areas to checklist

## Issue Isolation (07)
- One active issue at a time
- New issues go to `memory/known_issues.md`, not active work
- Switch only with user authorization
- On switch: pause current, clear plans, reload context

## Session Handoff (06)
Write to `memory/session_handoff.md`: summary, completed work, in-progress, blocked, decisions, next steps, modified files.
Then update: `memory/progress_log.md`, `memory/change_log.md`, `memory/project_state.md`, `active/active_context.md`.

## Error Recovery (15)
- Log every attempt in `active/active_issue.md ## Attempted Solutions` BEFORE trying
- Three failures = STOP, analyze root cause, present options to user
- Circular pattern detected = STOP, re-read original problem, consider if real issue is elsewhere

## Context Compiler (02)
1. Classify work type: bug-fix | new-feature | refactor | investigation | ingestion | maintenance | deployment | security | onboarding
2. Load profile: active state + relevant protocols + component summaries
3. Check active peaks for profile extensions and custom work types
4. Check registry for relevant components (status=ready, context_cost fits)
5. Update `active/active_context.md` with loaded context

## Parallel Work (09)
- Parallelize only independent tasks (no shared files)
- Each agent owns its files; shared resources (registries) updated by parent after merge
- Skill creation pattern: agents write 3 files each, parent updates registry
- Audit pattern: agents report findings only, parent applies fixes

## Scope Management (08)
- Before any work: "Is this in scope?" → check change plan
- Scope creep signals: plan modified 2+ times, touching unplanned files, "while I'm here" thoughts
- Legitimate expansion: STOP, update plan, inform user, get confirmation
- Self-inflicted creep: log observations in known_issues.md, continue original scope

## Confidence Calibration (16)
- Rate assumptions: high (verified) | medium (inferred) | low (guessed) | unknown
- Verify low/unknown items BEFORE acting on them
- Record in active_context.md Confidence Map
- After task: compare confidence ratings with outcomes → calibrate

## Knowledge Extraction (12)
- Layer 1 (5 min): structure, stack, entry points, config
- Layer 2 (10 min): architecture, data flow, abstractions, dependencies
- Layer 3 (10 min): conventions (naming, errors, state, imports, tests)
- Layer 4 (ongoing): sensitive areas → regression checklist
- Capture reusable patterns as knowledge packs

## Ingestion (10) + Readiness Gate (11)
1. Raw material → `incoming/`
2. Normalize: source + manifest.yaml + summary.md
3. Register in `docs/registry/` indexes
4. Verify: all fields populated, source self-contained, status=ready
5. Promote to `frameworks/` | `skills/` | `knowledge/`

## Context Maintenance (03)
- After each logical step → update `active/active_context.md`
- After each file change outside MP → append `memory/recent_deltas.md`
- After each task → update `memory/progress_log.md`
- Scope change detected → STOP, re-run context compiler, update plans

## Memory Rotation (04)
- Check file sizes during session handoff
- `recent_deltas.md`: keep last 3 sessions, archive older to `memory/archive/deltas/`
- `progress_log.md`: keep last 10 sessions, archive to `memory/archive/progress/`
- `change_log.md`: keep last 20 entries, archive to `memory/archive/changes/`
- `known_issues.md`: move resolved issues to `memory/archive/resolved_issues.md`

## Project Integration (05)
- MP as subdirectory: place in `.melted-peak/`, reference from project CLAUDE.md
- MP at root: add project-specific section to bottom of CLAUDE.md
- Rule priority: project code rules > MP process rules
- Upgrade: back up memory/ and active/, replace docs/, restore backups

## Self-Audit (20)
- Run every 5th session or on `/audit`
- Check: registry integrity, cross-references, dependency map, active state freshness, memory health, skill quality, protocol weight
- Report to `memory/metrics/audit_log.md`
- Severity: critical (fix now) > warning (fix during audit) > info (note for retro)

## Retrospective (skill)
- Run after resolving issues (especially 2+ attempt ones) or on `/retro`
- Gather evidence → analyze effectiveness → feed back into system → log metrics → check patterns
- Updates: regression checklist, skills, context profiles, architecture decisions
- Safety: protocol changes require user confirmation, one improvement at a time

## Peak Management (skill)
- `/peak import [source]` → validate structure → stage in `peaks/[name]/`
- `/peak mount [name]` → conflict check → dependency check → register components → merge profiles → ready
- `/peak unmount [name]` → dependency check → deregister → remove profiles → mark unmounted
- `/peak create` → interview domain/stack → generate peak → mount
- Peaks extend the context compiler via `peaks/active_profiles.yaml` (overlay, not core modification)
- Peak-provided skills registered with namespace: `[peak-name]/[skill-name]`
- Conflicts enforced: two peaks declaring each other in `conflicts.peaks` cannot coexist

## Self-Improvement Loops
1. Pattern journal: log repeated workflows → skill router at 3 occurrences
2. Context tracking: log used/unused components → tune compiler profiles
3. Post-completion retro: extract lessons → update skills and protocols
4. Regression growth: every bug fix → checklist entry
5. Confidence mapping: rate assumptions → verify low-confidence first
