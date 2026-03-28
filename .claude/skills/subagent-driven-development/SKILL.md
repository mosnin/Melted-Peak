---
name: subagent-driven-development
description: "Use when executing implementation plans with independent tasks that can run in sequence — dispatches fresh subagent per task with two-stage review"
user-invocable: false
---

# Subagent-Driven Development

Execute implementation plans by dispatching one subagent per task with mandatory two-stage review.

**Execution Loop (per task):**

1. **Extract** — read full task text from plan (never summarize)
2. **Dispatch Implementer** — fresh subagent with full task text and relevant context
3. **Implementer Reports**: DONE, DONE_WITH_CONCERNS, NEEDS_CONTEXT, or BLOCKED
4. **Spec Compliance Review** — does output match every acceptance criterion? PASS/FAIL
5. **Code Quality Review** — style, error handling, naming, tests, security? PASS/FAIL
6. **On FAIL** — re-dispatch implementer with specific fix list
7. **On PASS** — mark complete, move to next task

**After all tasks:** final integration review of combined implementation.

**Model Selection:** cheap models for mechanical/scaffolding tasks and spec reviews; capable models for integration work, quality reviews, and debugging.

**Red Flags — never do these:**
- Skip reviews (both stages mandatory, every task)
- Proceed with unfixed FAIL verdicts
- Dispatch parallel implementers
- Summarize task spec for implementer
- Let implementer self-review
- Skip final integration review

**Rationalization Table:**

| Excuse | Reality |
|--------|---------|
| "Reviews slow me down" | Cheaper than debugging later |
| "Too simple to review" | Simple tasks still drift from spec |
| "Review at the end" | Late finds compound on bad foundations |
| "Parallel is faster" | Creates conflicts and inconsistent state |
| "Summarize is fine" | Summaries lose edge cases |
| "Spec passed, quality fine" | Spec and quality are orthogonal |

See `skills/subagent-driven-development/source/SKILL.md` for full detail.
