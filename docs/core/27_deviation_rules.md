# Deviation Rules

When executing a change plan, deviations from the plan are inevitable. These rules classify deviations and define the correct response for each type.

## The 4 Deviation Rules

### Rule 1: Auto-Fix Bugs (DO NOT ASK)

If you encounter a bug during execution that blocks progress:
- Fix it immediately
- Log the fix in `active/active_context.md` under Session Notes
- Continue with the plan
- Add the bug's location to `active/regression_checklist.md`

**Examples:** null pointer, missing import, typo in variable name, off-by-one error

### Rule 2: Auto-Add Missing Critical Functionality (DO NOT ASK)

If the plan omitted something that is clearly required for the plan to work:
- Add it as part of the current task
- Log what was added and why in `active/active_context.md`
- Keep it minimal — only what's needed for the plan to succeed

**Examples:** missing error handling that would crash the app, missing database migration that the new code requires, missing type definition referenced by planned code

### Rule 3: Auto-Fix Blockers (DO NOT ASK)

If an external dependency, environment issue, or tooling problem blocks execution:
- Fix the blocker
- Document the fix in `active/active_context.md`
- Continue with the plan

**Examples:** wrong package version, missing env variable, broken test fixture, stale lock file

### Rule 4: ASK About Architectural Changes (ALWAYS ASK)

If the deviation changes the approach, data model, API contract, or system design:
- STOP execution
- Describe the deviation and why it's needed
- Present options with tradeoffs
- Wait for user decision before proceeding

**Examples:** need to change the database schema differently than planned, API endpoint shape needs to change, new dependency required that wasn't in the plan, scope significantly larger than expected

## Decision Flowchart

```
Is the deviation a bug blocking progress?
  → YES: Auto-fix (Rule 1)
  → NO: Continue...

Is the deviation a missing piece clearly required by the plan?
  → YES: Auto-add (Rule 2)
  → NO: Continue...

Is the deviation an environment/tooling blocker?
  → YES: Auto-fix (Rule 3)
  → NO: Continue...

Does the deviation change architecture, design, or scope?
  → YES: ASK the user (Rule 4)
  → NO: Continue...

None of the above?
  → Default to ASK. The cost of pausing is low.
```

## Logging

ALL deviations (even auto-fixed ones) must be logged in `active/active_context.md` under Session Notes with:
- What deviated from the plan
- Which rule was applied
- What was done

This creates an audit trail for the retrospective.

## Integration

- Referenced by: `skills/subagent-driven-development/`, change plan execution, `/plan` skill
- Updates: `active/active_context.md` (session notes), `active/regression_checklist.md` (Rule 1 bugs)
