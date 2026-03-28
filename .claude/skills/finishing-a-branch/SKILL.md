---
name: finishing-a-branch
description: Use when all tasks on a development branch are complete and you need to decide what to do next — merge, PR, keep, or discard
user-invocable: false
---

# Finishing a Branch

Structured decision for completed branch work.

**Pre-completion checklist:**
- [ ] All tests pass (run them fresh, verify output)
- [ ] No uncommitted changes
- [ ] Change plan marked complete
- [ ] Regression checklist reviewed

**Decision tree:**
- **Merge directly** — small/solo work, tests green, no review needed
- **Create PR** — needs review, documents decisions for future reference
- **Keep branch** — work paused, will resume later
- **Discard** — abandoned, no value in keeping

**Post-completion:** update active_context.md, progress_log.md, close active_issue.md. Clean up worktree if applicable.

**Rationalization Table:**

| Excuse | Reality |
|--------|---------|
| "Tests passed earlier" | Run them again — code may have changed |
| "Small change, skip PR" | PRs document decisions for future reference |
| "I'll clean up later" | Later never comes. Clean up now. |

See `skills/finishing-a-branch/source/SKILL.md` for full workflow.
