# Subagent-Driven Development

## Purpose

Execute implementation plans by dispatching a fresh subagent per task, with a mandatory two-stage review after each task: spec compliance first, then code quality. This prevents drift from the plan, catches quality issues early, and keeps each subagent focused on a single bounded unit of work.

## Trigger

When an implementation plan exists (in `active/change_plan.md` or provided by the user) with independent tasks that can be executed in sequence.

## Workflow

### Step 1: Extract Tasks from the Plan

Read the full implementation plan. For each task, capture:
- **Task ID** and title
- **Full task description** (never summarize — pass complete text to the implementer)
- **Files to create or modify**
- **Acceptance criteria** (what "done" looks like)
- **Dependencies** on other tasks (determines execution order)

Order tasks so dependencies are satisfied before dependents execute.

### Step 2: Per-Task Execution Loop

For each task, execute this three-phase cycle:

#### Phase A: Implementer Subagent

Dispatch a fresh subagent with:
- The full task text (verbatim from the plan)
- Relevant context files (only what this task needs)
- Clear instruction: implement exactly what the task describes, nothing more

The implementer reports one of four statuses:
- **DONE** — task completed as specified
- **DONE_WITH_CONCERNS** — completed but flagged issues for review (e.g., "this API seems deprecated")
- **NEEDS_CONTEXT** — cannot proceed without additional information (specify what)
- **BLOCKED** — dependency or environment issue prevents completion (specify blocker)

On NEEDS_CONTEXT or BLOCKED: pause, resolve the issue, then re-dispatch.

#### Phase B: Spec Compliance Review

A reviewer checks the implementer's output against the plan:
- Does the implementation match every acceptance criterion?
- Were all specified files created or modified?
- Does the implementation do anything NOT in the spec? (scope creep)
- Are edge cases from the spec handled?

Verdict: PASS or FAIL with specific items to fix.
On FAIL: re-dispatch implementer with the specific fix list.

#### Phase C: Code Quality Review

A second reviewer checks implementation quality:
- Code style consistency with the existing codebase
- Error handling and edge cases
- Naming conventions and readability
- Test coverage (if tests were part of the task)
- No introduced security issues or performance regressions

Verdict: PASS or FAIL with specific items to fix.
On FAIL: re-dispatch implementer with the specific fix list.

### Step 3: Mark Task Complete

After both reviews pass, mark the task complete and move to the next task. Update progress in `active/active_context.md`.

### Step 4: Final Integration Review

After all tasks are complete, perform a final review of the entire implementation:
- Do all tasks integrate correctly together?
- Are there gaps between tasks that no single task covers?
- Does the combined implementation satisfy the original plan's goals?
- Run the full verification suite (tests, linter, build)

## Model Selection Guidance

Not all tasks require the same model capability. Match model cost to task complexity:

| Task Type | Recommended Model Tier | Rationale |
|-----------|----------------------|-----------|
| Boilerplate, scaffolding, config files | Cheap (fast) | Mechanical work, low judgment needed |
| Straightforward feature implementation | Cheap (fast) | Clear spec, bounded scope |
| Complex integration, cross-cutting changes | Capable (smart) | Requires understanding system interactions |
| Review (spec compliance) | Cheap (fast) | Checklist comparison against spec |
| Review (code quality) | Capable (smart) | Requires judgment about design and style |
| Final integration review | Capable (smart) | Requires holistic system understanding |
| Debugging NEEDS_CONTEXT or BLOCKED | Capable (smart) | Requires diagnosis and creative solutions |

Default to cheap models. Escalate to capable models when the task requires judgment, integration reasoning, or handling ambiguity.

## Red Flags

Never do these:

- **Never skip reviews.** Both spec compliance and code quality reviews are mandatory for every task. No exceptions for "simple" tasks.
- **Never proceed with unfixed review failures.** A FAIL verdict must be resolved before moving to the next task. Accumulated tech debt from skipped fixes compounds rapidly.
- **Never dispatch parallel implementers.** Tasks execute sequentially. Parallel dispatch creates merge conflicts, inconsistent assumptions, and makes debugging impossible.
- **Never summarize the task spec for the implementer.** Pass the full task text. Summaries lose critical details.
- **Never let the implementer self-review.** The reviewer must be a separate evaluation, not the implementer checking its own work.
- **Never skip the final integration review.** Individual task correctness does not guarantee system correctness.

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Reviews slow me down" | Reviews catch issues early — cheaper than debugging later |
| "This task is too simple to review" | Simple tasks still drift from spec; reviews take seconds for simple work |
| "I'll review everything at the end" | Late reviews find issues after dependent tasks built on bad foundations |
| "The implementer is confident it's correct" | Confidence is not evidence — see verification-before-completion |
| "Parallel dispatch would be faster" | Parallel creates merge conflicts and inconsistent state; sequential is safer and often faster overall |
| "I can summarize the task, the implementer will get it" | Summaries lose edge cases, constraints, and acceptance criteria |
| "The spec review passed, code quality must be fine" | Spec compliance and code quality are orthogonal — correct behavior in bad code is still bad code |
| "We're behind schedule, skip this review" | Skipping reviews creates the schedule pressure you're trying to avoid |

## Integration

- **Brainstorming** (`skills/brainstorming/`): Use brainstorming to define the problem and spec before creating the implementation plan that this skill executes.
- **Writing Plans** (`skills/plan/`): The implementation plan consumed by this skill should follow the change plan format from the plan skill.
- **Verification Before Completion** (`skills/verification-before-completion/`): The final integration review step must follow verification-before-completion discipline — run actual commands, read actual output.
- **Retrospective** (`skills/retrospective/`): After completing all tasks, run a retrospective to extract lessons about task sizing, review effectiveness, and model selection accuracy.
- **Deviation handling**: Follow `docs/core/27_deviation_rules.md` for auto-fix vs ask decisions
