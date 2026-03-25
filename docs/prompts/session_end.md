# Session End Prompt

Use this prompt before ending a session to execute the handoff protocol.

---

## Prompt

```
Execute the Melted Peak session handoff protocol:

1. Summarize what was accomplished this session
2. List any in-progress or blocked work
3. Record decisions made and their rationale
4. Log any discovered issues to memory/known_issues.md
5. Define the next 3 priority steps for the next session
6. Write the handoff to memory/session_handoff.md
7. Update memory/progress_log.md
8. Update memory/change_log.md (if code changes were made)
9. Update memory/project_state.md
10. Update active/active_context.md with end-of-session state

Confirm when the handoff is complete.
```

## When to Use
- Before ending any session
- When the user types `/handoff`
- If a session is being cut short (use abbreviated version)
