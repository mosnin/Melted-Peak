# Context Recovery Prompt

Use when context feels lost mid-session -- you're unsure what was decided, what the goal is, or what's been tried.

---

## Prompt

```
Context recovery -- I've lost track. Rebuild context now:

1. Read active/active_context.md -- what is the current goal?
2. Read active/active_issue.md -- what problem are we solving?
3. Read active/change_plan.md -- what was the plan?
4. Read memory/recent_deltas.md -- what has changed this session?
5. Read active/active_issue.md ## Attempted Solutions -- what has been tried?

Then:
- Summarize where we are in 3 sentences
- Identify the immediate next action
- Flag any assumptions that need verification (mark as low confidence)
- Update active/active_context.md with the rebuilt context

Do NOT continue work until context is rebuilt and confirmed.
```

## When to Use
- After a long pause in the session
- When you realize you're unsure what the goal is
- When work seems to be going in circles
- After context window compression events
- When resuming after an interruption
