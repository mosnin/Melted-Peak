# Scope Management Protocol

Defines how to detect, prevent, and handle scope creep. Scope drift is the second biggest cause of project failures (after context loss).

---

## The Scope Question

Before doing ANY work, ask: "Is this in scope?"

### Decision Tree

```
Is this in the active change plan?
├── Yes → Do it
└── No
    ├── Is it required to complete the current task?
    │   ├── Yes → Update the change plan, then do it
    │   └── No
    │       ├── Would it take < 2 minutes and prevent a future bug?
    │       │   ├── Yes → Do it, log in recent_deltas.md with note
    │       │   └── No → Log it, don't do it
    │       └── Is the user asking for it right now?
    │           ├── Yes → Create a new change plan for it
    │           └── No → Log to memory/known_issues.md
```

## Scope Creep Signals

You are experiencing scope creep when:
- The change plan has been modified more than twice during execution
- You're touching files not listed in the original plan
- "While I'm here" thoughts keep occurring
- The task has taken 2x longer than initially expected
- You've discovered 3+ "improvements" during the work

## When Scope Expands Legitimately

Sometimes scope must expand. The difference between legitimate expansion and creep:

| Legitimate | Creep |
|-----------|-------|
| "This file must change for the fix to work" | "This file could be better" |
| "The test revealed a dependency" | "Let's also refactor this" |
| "The user explicitly asked for more" | "They'll probably want this too" |

When scope expands legitimately:
1. STOP current work
2. Update `active/change_plan.md` with the expanded scope
3. Update `active/active_context.md` with the scope change
4. Inform the user: "The scope has expanded because [reason]. Here's the updated plan."
5. Get confirmation before continuing

## Estimation Improvement

After each completed task, compare estimated scope vs. actual scope:
- Were more files changed than planned? Why?
- Did the task take longer than expected? Why?
- Log the delta in the retrospective

Over time, this feedback loop improves estimation accuracy.

## Saying No to Yourself

The most important scope management skill is recognizing when YOU are adding scope. Common self-inflicted creep:
- "This variable name is bad" (rename it later)
- "This function should be extracted" (refactor later)
- "This error message could be better" (improve later)
- "This test is incomplete" (expand later)

Log these observations in `memory/known_issues.md` and continue with the original scope.
