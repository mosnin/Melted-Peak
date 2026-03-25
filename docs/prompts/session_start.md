# Session Start Prompt

Use this prompt at the beginning of a session to boot the Melted Peak system.

---

## Prompt

```
Boot the Melted Peak context system:

1. Read docs/core/00_system_overview.md
2. Read active/active_context.md
3. Read memory/session_handoff.md
4. Read active/active_issue.md (if non-empty)
5. Read active/change_plan.md (if non-empty)

Then report:
- Current goal and status
- What the last session accomplished
- What the next steps are
- Any blockers or known issues

If resuming previous work, run the context compiler to load relevant components.
If starting fresh, await task assignment.
```

## When to Use
- Every session start
- After a context reset
- When the user types `/boot`
