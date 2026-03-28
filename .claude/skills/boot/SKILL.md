---
name: boot
description: Run the full Melted Peak boot sequence — reads active context, session handoff, active issue, change plan, validation plan, and mounted peaks; reports current state
user-invocable: true
---

# /boot — Full Boot Sequence

Read files in this exact order:

1. `docs/core/00_system_overview.md` — system architecture
2. `active/active_context.md` — current working state
3. `memory/session_handoff.md` — pick up from last session
4. `active/active_issue.md` — current focus (skip if stub)
5. `active/change_plan.md` — planned work (skip if stub)
6. `active/validation_plan.md` — verification steps (skip if stub)
7. `peaks/active_peaks.yaml` — mounted peaks

After reading, report:
- Current goal and status
- Active issue (if any)
- Blockers from last session
- Recommended next action
