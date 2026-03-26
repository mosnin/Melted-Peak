# Issue Diagnosis Prompt

Use this prompt when a bug or issue is reported to systematically diagnose it.

---

## Prompt

```
Diagnose this issue systematically:

1. Read active/active_issue.md (if it exists) for previous context
2. Read memory/known_issues.md -- has this been seen before?
3. Read memory/recent_deltas.md -- what changed recently that could cause this?

Then ask yourself:
- Can I reproduce the issue? Under what exact conditions?
- What is the expected behavior vs. actual behavior?
- When did this last work correctly? What changed since then?
- Is this a symptom or a root cause? (Trace the chain)

Write findings to active/active_issue.md before attempting any fix.
If three diagnosis approaches fail, invoke the three-strike rule.
```

## When to Use
- Bug reported by user
- Unexpected behavior discovered
- Test failure with unclear cause
