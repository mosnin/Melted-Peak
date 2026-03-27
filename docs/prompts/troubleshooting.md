# Troubleshooting Prompt

Use when something isn't working and you need a structured investigation approach.

---

## Prompt

```
Troubleshoot this issue systematically:

1. What EXACTLY is the problem? (not "it's broken" -- specific error, behavior, condition)
2. What SHOULD happen instead?
3. When did this last work correctly?
4. What changed between then and now?
   - Check memory/recent_deltas.md for recent changes
   - Check git log for recent commits
   - Check if environment/config changed

5. Can you reproduce it?
   - If yes: what are the exact steps?
   - If no: is it timing-dependent, data-dependent, or environment-dependent?

6. Where does it fail?
   - Trace the execution path from trigger to error
   - Add logging at decision points if needed
   - Find the first point where actual diverges from expected

7. Load knowledge/debugging-patterns/ for error pattern references
8. Load skills/debugging/ for the systematic diagnosis workflow
9. Write findings to active/active_issue.md BEFORE attempting any fix

Do NOT fix anything until the diagnosis is complete.
```

## When to Use
- Something stopped working
- Error with unclear cause
- Behavior differs between environments
- Intermittent failure
