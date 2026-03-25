# Melted Peak -- Engineering Context Operating System

You are operating as a senior software engineer with persistent memory.
This repository IS the Melted Peak system. Every file has a defined purpose and lifecycle.

---

## Boot Sequence

On every session start, read files in this exact order:

1. `docs/core/00_system_overview.md` -- understand the system architecture
2. `active/active_context.md` -- understand current working state
3. `memory/session_handoff.md` -- pick up where the last session left off
4. `active/active_issue.md` -- understand current focus (skip if empty/stub)
5. `active/change_plan.md` -- understand planned work (skip if empty/stub)
6. `active/validation_plan.md` -- understand verification steps (skip if empty/stub)
7. Load additional context via `docs/core/02_context_compiler.md` as needed

Do NOT read all files on every boot. Use the context compiler to select relevant files.

---

## Operational Rules

### Context Maintenance
- Update `active/active_context.md` after completing each logical step
- Append to `memory/recent_deltas.md` after every change to files outside Melted Peak
- Update `memory/progress_log.md` after completing each task
- ALWAYS run the session handoff protocol before ending a session

### Engineering Discipline
- ONE issue at a time. Follow `docs/core/07_issue_isolation_protocol.md`
- ALWAYS write a change plan before modifying code. Follow `docs/core/23_change_control_system.md`
- ALWAYS verify changes don't break existing work. Follow `docs/core/25_regression_prevention.md`
- Never assume previous context is still accurate -- verify from files

### Component Management
- New frameworks, skills, and knowledge MUST go through `incoming/` first
- Nothing leaves `incoming/` without passing the readiness gate (`docs/core/11_readiness_gate.md`)
- Follow `docs/core/10_ingestion_and_normalization_rules.md` for all new components

---

## User Commands

| Command | Action |
|---------|--------|
| `/boot` | Read the full boot sequence and report current state |
| `/status` | Summarize active context, issue, and recent progress |
| `/handoff` | Execute session handoff protocol |
| `/compile` | Run context compiler for the current task |
| `/plan` | Create or update a change plan |
| `/validate` | Run validation plan and regression checklist |
| `/ingest` | Begin ingestion workflow for a new component |
| `/issues` | Show known issues from `memory/known_issues.md` |

---

## Anti-Patterns -- Do NOT

- Do NOT read every file in `docs/core/` on every boot
- Do NOT skip the change plan for "small" changes unless explicitly trivial (comments, typos)
- Do NOT work on multiple issues simultaneously
- Do NOT use raw/unnormalized components from `incoming/`
- Do NOT end a session without updating `memory/session_handoff.md`
- Do NOT assume context from a previous session -- always verify from files

---

## Key References

- System overview: `docs/core/00_system_overview.md`
- Operating principles: `docs/core/01_operating_principles.md`
- Context compiler: `docs/core/02_context_compiler.md`
- Templates: `docs/templates/`
- Component registry: `docs/registry/`
