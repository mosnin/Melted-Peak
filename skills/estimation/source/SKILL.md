# Skill: Estimation

## Purpose
Systematic task estimation and complexity assessment that produces calibrated scope and time estimates. Breaks work into subtasks, identifies unknowns, assigns confidence levels, and integrates with change plans and retrospectives for continuous calibration.

## Trigger
- Before writing a change plan (estimate scope first)
- User asks "how long will this take?" or "how big is this?"
- Context compiler selects work type that benefits from scoping
- User says `/plan` and the task is non-trivial
- Before starting any work that touches 3+ files

---

## Workflow

### Phase 1: Classify Complexity

Assess the task against these complexity tiers:

| Tier | Description | Typical Scope | Example |
|------|-------------|---------------|---------|
| **Trivial** | Single obvious change, no ambiguity | 1 file, 1-5 lines | Fix a typo, update a comment |
| **Simple** | Clear change, one logical unit | 1-2 files, < 30 lines | Rename a variable, add a validation check |
| **Moderate** | Multiple related changes, some judgment needed | 3-5 files, 30-100 lines | Add a new API endpoint, refactor a function |
| **Complex** | Cross-cutting changes, design decisions, risk of regressions | 5+ files, 100+ lines | Restructure a module, change a data model |
| **Unknown** | Cannot classify without further investigation | Indeterminate | Unfamiliar codebase area, unclear requirements |

**If complexity is Unknown**: STOP estimating. First, investigate enough to reclassify. Read the relevant code, ask clarifying questions, check architecture decisions. Do not proceed with a change plan until complexity is at least Moderate or below.

### Phase 2: Decompose Into Subtasks

Break the task into concrete subtasks. Each subtask should be:
- **Independently verifiable** -- you can confirm it's done without completing the whole task
- **Small enough to estimate** -- if a subtask feels complex on its own, break it further
- **Ordered by dependency** -- which subtasks must happen before others?

Write the decomposition in this format:

```markdown
## Subtask Decomposition

1. [Subtask description] -- [file(s) affected] -- [estimated effort: small/medium/large]
2. [Subtask description] -- [file(s) affected] -- [estimated effort: small/medium/large]
3. ...

**Dependencies**: 1 before 2, 2 before 3, etc.
**Parallelizable**: [which subtasks are independent of each other]
```

Effort scale:
- **Small**: Straightforward, no decisions to make, < 15 lines changed
- **Medium**: Requires some judgment, 15-50 lines changed
- **Large**: Requires design thinking, 50+ lines changed, or touches sensitive areas

### Phase 3: Identify Unknowns and Risks

For each subtask, check for factors that inflate effort:

| Risk Factor | Impact | Mitigation |
|-------------|--------|------------|
| **Unfamiliar code** | Effort x1.5-2 | Read the code first, add investigation subtask |
| **External dependencies** | Effort x1.5-3 | Check API docs, version constraints, availability |
| **Unclear requirements** | Effort x2-4 | Ask clarifying questions BEFORE estimating |
| **No existing tests** | Effort x1.5 | Add testing subtask to the estimate |
| **Sensitive area** (on regression checklist) | Effort x1.5 | Add extra verification subtask |
| **Shared/imported code** | Effort x1.5-2 | Trace all callers, add regression checks |
| **Concurrent work** | Effort x1.5 | Check for conflicts with other active changes |

Write the risk assessment:

```markdown
## Risk Assessment

| Unknown/Risk | Affected Subtask(s) | Severity | Mitigation |
|-------------|---------------------|----------|------------|
| [description] | [subtask numbers] | low/medium/high | [what to do about it] |

**Overall risk level**: low | medium | high
```

### Phase 4: Estimate Scope

Aggregate the subtask analysis into a scope estimate:

```markdown
## Scope Estimate

- **Files to modify**: [count and list]
- **Files to create**: [count and list]
- **Logical changes**: [count -- each distinct behavior change]
- **Tests needed**: [count -- new tests, modified tests]
- **Estimated total lines changed**: [range]
- **Complexity tier**: [trivial/simple/moderate/complex]
```

### Phase 5: Assign Confidence Level

Based on the unknowns identified in Phase 3, assign a confidence level:

| Confidence | Meaning | When to Use |
|------------|---------|-------------|
| **High** | Estimate accurate within +/-20% | No unknowns, familiar code, clear requirements, similar past work |
| **Medium** | Estimate accurate within +/-50% | Some unknowns but bounded, mostly familiar code, requirements mostly clear |
| **Low** | Estimate accurate within +/-100% | Significant unknowns, unfamiliar code, unclear requirements, no similar past work |

**If confidence is Low**: Flag this explicitly in the change plan. Consider whether to investigate further before committing to the plan. Low confidence means the task could take twice as long as estimated.

### Phase 6: Check Time Signals

Look for calibration data from past work:

1. **Read `memory/progress_log.md`**: Find similar past tasks. How long did they actually take? How did estimates compare?
2. **Read `memory/metrics/retrospectives.md`**: Check for scope drift patterns. If past estimates consistently under-shot, apply a correction factor.
3. **Code complexity indicators**: Deep nesting, long functions, many dependencies, poor naming -- all slow work down. Note these if present.

If similar past work exists, use it to sanity-check the estimate:
- Past task took X effort with Y scope
- Current task has Z scope
- Adjusted estimate: proportional, with risk multiplier

### Phase 7: Check Size Boundaries

Apply these guardrails:

- **> 5 files modified**: Consider splitting into multiple change plans
- **> 200 lines changed**: Consider splitting into phases
- **> 3 unknowns rated medium or high**: Recommend an investigation phase before the implementation phase
- **Complexity tier "complex" + confidence "low"**: STOP. Tell the user: "This is too big and uncertain for one change plan. Recommend splitting into: (1) investigation phase to resolve unknowns, (2) implementation phase with better estimates."

---

## Output Format

Include the estimation in `active/change_plan.md` under a `## Scope Estimate` section:

```markdown
## Scope Estimate

**Complexity**: [tier]
**Confidence**: [high/medium/low] (+/-[percentage])

**Subtasks**:
1. [subtask] -- [effort] -- [risk: none/low/medium/high]
2. ...

**Scope**:
- Files: [count] modified, [count] created
- Logical changes: [count]
- Tests: [count] new, [count] modified
- Estimated lines: [range]

**Risks**:
- [risk 1]: [mitigation]
- ...

**Size check**: [within bounds / recommend split]
**Calibration note**: [reference to similar past work, if any]
```

---

## Estimation Calibration

After the task is complete, the retrospective skill compares actual vs. estimated:

- **Actual files changed** vs. estimated
- **Actual lines changed** vs. estimated
- **Actual subtask count** vs. estimated (were subtasks missed?)
- **Actual complexity** vs. estimated tier
- **Time/effort** vs. confidence band -- did the actual fall within the confidence range?

This comparison is logged in `memory/metrics/retrospectives.md` and used to improve future estimates. Patterns to watch for:

| Pattern | Meaning | Adjustment |
|---------|---------|------------|
| Consistently under-estimating scope | Optimism bias | Add 30% buffer to future estimates |
| Consistently over-estimating scope | Excessive caution | Reduce buffer, trust initial assessment more |
| Unknowns always blow up estimates | Investigation phase too short | Require investigation subtask for any medium+ unknown |
| Subtasks frequently missed | Decomposition too shallow | Add a "what else could be affected?" check |

---

## Critical Rules

- **Never skip estimation for moderate or complex tasks.** Trivial and simple tasks can use a lightweight mental estimate.
- **Unknown complexity means stop and investigate.** Do not estimate what you do not understand.
- **Low confidence must be flagged.** The user needs to know when an estimate is unreliable.
- **Push back on oversized tasks.** A change plan that touches too many files or has too many unknowns should be split.
- **Calibrate continuously.** Every retrospective should compare actual vs. estimated to improve future accuracy.

## Anti-Patterns

- Estimating without reading the code -- you're guessing, not estimating
- Ignoring unknowns to make the estimate look smaller -- unknowns are where the time actually goes
- Refusing to give an estimate because "it depends" -- give a range with a confidence level instead
- Estimating the whole task as one blob -- always decompose into subtasks
- Never updating estimates when new information arrives -- re-estimate when unknowns are resolved
