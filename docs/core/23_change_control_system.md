# Change Control System

Defines how changes are planned before implementation. Unplanned changes are the primary source of regressions.

---

## When a Change Plan Is Required

- Any modification to code files
- Any modification to configuration files
- Any structural change to Melted Peak itself
- Any dependency addition or removal

## When a Change Plan Is NOT Required

- Fixing typos in comments or documentation
- Formatting-only changes
- Updating Melted Peak active/memory files (these are operational, not code)

## Creating a Change Plan

Write to `active/change_plan.md` using the template from `docs/templates/change_plan_template.md`.

### Required Sections

#### 1. Objective
What is this change trying to accomplish? One sentence.

#### 2. Scope
Which files will be modified? List every file with the nature of the change:
```markdown
- `src/auth/login.ts` -- Add token refresh logic
- `src/auth/types.ts` -- Add RefreshToken type
- `tests/auth/login.test.ts` -- Add refresh token tests
```

#### 3. Approach
How will the change be implemented? Brief description of the strategy.

#### 4. Risk Assessment
What could go wrong?
- **High risk**: Changes to shared utilities, database schemas, auth flows
- **Medium risk**: Changes to business logic, API contracts
- **Low risk**: Adding new files, isolated changes, test additions

#### 5. Dependencies
Does this change depend on other changes being completed first?

#### 6. Rollback Strategy
How do we undo this if it breaks something?
- For code changes: git revert or specific manual steps
- For data changes: backup/restore procedure

#### 7. Validation Criteria
How will we know this change is correct? This feeds into `active/validation_plan.md`.

## Executing a Change Plan

1. **Get confirmation.** Show the plan to the user. Proceed only with approval.
2. **Follow the plan.** Make changes in the order specified.
3. **Log deviations.** If the plan needs adjustment during execution, update `active/change_plan.md` and note the deviation in `memory/recent_deltas.md`.
4. **Run validation.** Execute the validation plan after changes are complete.
5. **Close the plan.** Mark `active/change_plan.md` as completed with the outcome.

## Deviation Handling

If during execution you discover that:
- Additional files need to change: update the plan, get approval for expanded scope
- The approach won't work: stop, update the plan with findings, propose alternative
- A blocker is found: document the blocker, pause the plan, inform the user

Never silently deviate from the plan. Transparency prevents compound errors.
