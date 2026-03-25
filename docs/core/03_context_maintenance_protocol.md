# Context Maintenance Protocol

Defines how context is updated during active work. Context that isn't maintained becomes stale and dangerous.

---

## When to Update

### After Every Logical Step
Update `active/active_context.md` with:
- What was just completed
- What the next action is
- Any scope changes

### After Every File Change Outside Melted Peak
Append to `memory/recent_deltas.md`:
```markdown
### [timestamp or sequence number]
- **File**: path/to/changed/file
- **Change**: Brief description of what changed
- **Reason**: Why the change was made
- **Impact**: What this affects (if non-obvious)
```

### After Completing a Task
Update `memory/progress_log.md`:
```markdown
### [date] -- [task description]
- **Status**: completed | partial | blocked
- **Changes made**: List of files modified
- **Decisions**: Any decisions made and rationale
- **Notes**: Anything the future needs to know
```

### When Discovering a New Issue
Append to `memory/known_issues.md`:
```markdown
### [issue title]
- **Discovered during**: [what task]
- **Severity**: critical | high | medium | low
- **Description**: What's wrong
- **Notes**: Any initial observations
```
Do NOT switch to the new issue. Continue current work.

### When Making an Architecture Decision
Append to `memory/architecture_decisions.md`:
```markdown
### ADR-[number]: [title]
- **Date**: [date]
- **Status**: proposed | accepted | deprecated | superseded
- **Context**: Why this decision was needed
- **Decision**: What was decided
- **Consequences**: What follows from this decision
```

---

## Scope Change Detection

If during work you notice that:
- The task is larger than initially understood
- New dependencies are discovered
- The change plan needs significant revision
- The work type has shifted (e.g., bug-fix became refactor)

Then:
1. STOP current work
2. Update `active/active_context.md` with the scope change
3. Re-run the context compiler if the work type changed
4. Update the change plan if it exists
5. Inform the user of the scope change before proceeding

---

## Accuracy Rules

- If you update a file, re-read it after writing to verify accuracy
- If active context contradicts memory files, investigate before proceeding
- If you're unsure whether context is current, re-read the source files
- Never propagate uncertain information as fact -- flag it as uncertain
