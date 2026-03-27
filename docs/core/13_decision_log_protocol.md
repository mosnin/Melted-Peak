# Decision Log Protocol

Defines how engineering decisions are captured, structured, and referenced. Prevents re-debating settled decisions and preserves the rationale for future sessions.

---

## Why Log Decisions

Every engineering decision has a context that made it correct at the time. Without recording that context:
- Future sessions re-debate the same question
- Changes are made that contradict previous reasoning
- The rationale for "why it's this way" is lost

## What Counts as a Decision

Log a decision when:
- You choose between two or more valid approaches
- You explicitly decide NOT to do something (negative decisions are valuable)
- You choose a technology, library, or pattern
- You set a convention that affects future work
- You make a tradeoff (speed vs. correctness, simplicity vs. flexibility)

Do NOT log:
- Obvious implementation details (which variable name to use)
- Decisions forced by the framework with no real alternative
- Temporary choices that will be revisited immediately

## ADR Format

Write to `memory/architecture_decisions.md`:

```markdown
### ADR-[number]: [title]
- **Date**: [date]
- **Status**: proposed | accepted | deprecated | superseded by ADR-[N]
- **Context**: Why this decision was needed (the problem or question)
- **Options Considered**:
  1. [Option A] -- [pros / cons]
  2. [Option B] -- [pros / cons]
  3. [Option C] -- [pros / cons]
- **Decision**: What was chosen and why
- **Consequences**: What follows from this decision (positive and negative)
- **Revisit When**: Conditions that would make this decision worth re-evaluating
```

## Quick Decisions

For smaller decisions that don't warrant a full ADR:

Log inline in `active/active_context.md` under Session Notes:
```
Decision: Use zustand over Redux for client state
Reason: Simpler API, smaller bundle, team familiarity
Revisit if: state complexity grows beyond 10 slices
```

These get promoted to full ADRs during retrospective if they prove important.

## Referencing Decisions

When making a change that relates to a previous decision:
1. Check `memory/architecture_decisions.md` first
2. If a relevant ADR exists, reference it in the change plan
3. If the change contradicts an existing ADR, propose superseding it (don't silently violate)

## Decision Lifecycle

```
proposed → accepted → [in effect]
                         ↓
                    deprecated (no longer relevant)
                    OR superseded by ADR-N (replaced by better approach)
```

Deprecated decisions stay in the log (they're history, not garbage).
