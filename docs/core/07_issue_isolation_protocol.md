# Issue Isolation Protocol

Defines how to maintain focus on one issue at a time. Multi-issue work creates cross-contamination where changes for one issue break another.

---

## Core Rule

Only one issue may be active at any time. The active issue is defined in `active/active_issue.md`.

## Starting Work on an Issue

1. Write the issue to `active/active_issue.md` using the template from `docs/templates/active_issue_template.md`
2. Create a change plan in `active/change_plan.md` (see `docs/core/23_change_control_system.md`)
3. Run the context compiler to load relevant context
4. Begin work within the defined scope

## During Work

### If a New Issue Is Discovered

1. **Do NOT switch to it.** Continue current work.
2. Log it to `memory/known_issues.md` with:
   - Title
   - Severity (critical | high | medium | low)
   - Brief description
   - How it was discovered
3. Only switch if:
   - The discovered issue is **critical** AND blocks current work
   - The user explicitly authorizes the switch

### If a Switch Is Authorized

1. Update `active/active_issue.md` to mark current issue as `paused`
2. Write the paused state to `memory/progress_log.md`
3. Clear `active/change_plan.md` and `active/validation_plan.md`
4. Write the new issue to `active/active_issue.md`
5. Re-run the context compiler for the new issue
6. Create a new change plan

### Returning to a Paused Issue

1. Check `memory/progress_log.md` for where work was paused
2. Restore `active/active_issue.md` with the paused issue
3. Re-run the context compiler
4. Review `memory/recent_deltas.md` for changes made while paused
5. Update the change plan if the codebase changed

## Scope Boundaries

The active issue defines a scope. Stay within it:

- **In scope**: Changes directly required to resolve the issue
- **Out of scope**: Improvements noticed while working, unrelated cleanup, "while I'm here" changes
- **Edge case**: A change is technically out of scope but takes 30 seconds and prevents a future bug. Log it in `memory/recent_deltas.md` with a note explaining why it was included.

## Completion

1. Execute the validation plan
2. Run the regression checklist
3. Update `active/active_issue.md` with resolution status
4. Update `memory/progress_log.md`
5. Clear the issue or load the next one from `memory/known_issues.md`
