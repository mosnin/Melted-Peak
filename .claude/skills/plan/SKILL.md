---
name: plan
description: Create or update a change plan in active/change_plan.md before modifying any code — lists files, tasks, risks, and rollback strategy
user-invocable: true
---

# /plan — Change Plan

Create or update `active/change_plan.md` using `docs/templates/change_plan_template.md`.

Must include:
- **Goal**: what this change achieves
- **Files**: each file and what changes
- **Tasks**: checkbox list, each 2-5 min, with exact code when relevant
- **Expected outcome**: what success looks like
- **Rollback**: how to undo if something breaks
- **Verification**: what to run to confirm it worked
