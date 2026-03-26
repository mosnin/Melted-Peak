# Architecture Review Prompt

Use this prompt to evaluate architectural decisions or review system design.

---

## Prompt

```
Review the architecture of [system/feature]:

1. Read memory/architecture_decisions.md for existing ADRs
2. Read the relevant code to understand current structure
3. If a PRD exists (docs/prd.md), check alignment with requirements

Evaluate:
- Does the current architecture support the stated requirements?
- Are there single points of failure?
- Is the coupling between components appropriate?
- Are the abstractions at the right level? (too abstract = complex, too concrete = rigid)
- Are there obvious scalability bottlenecks?
- Does it follow the project's established patterns?

For each concern found:
- Severity: critical / important / nice-to-have
- Current risk: what could go wrong
- Suggested improvement
- Cost of change: easy / moderate / hard

Write findings to active/active_context.md.
Record decisions to memory/architecture_decisions.md as ADRs.
```

## When to Use
- Before starting a major feature
- When performance or scalability concerns arise
- During project kickoff (Phase 3 architecture planning)
- When technical debt is being evaluated
