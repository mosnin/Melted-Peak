# Session Handoff Protocol

Defines how work is preserved between sessions. A clean handoff means the next session picks up without re-discovery.

---

## When to Execute

- Before ending any session (mandatory)
- When the user says `/handoff`
- If a session is ending unexpectedly, write at minimum a one-paragraph summary

## Handoff Procedure

### Step 1: Summarize Progress

Write to `memory/session_handoff.md` using this structure:

```markdown
# Session Handoff

## Date
[current date]

## Summary
[2-3 sentences: what was the goal, what was accomplished]

## Completed Work
- [task 1 -- brief description]
- [task 2 -- brief description]

## In-Progress Work
- [task -- what state it's in, what remains]

## Blocked Items
- [item -- why it's blocked, what unblocks it]

## Decisions Made
- [decision -- rationale]

## Discovered Issues
- [issue -- severity, brief description]

## Next Steps
1. [most important next action]
2. [second priority]
3. [third priority]

## Active Files Modified This Session
- [file path -- nature of change]

## Context Notes
[Anything the next session needs to know that doesn't fit above]
```

### Step 2: Update Progress Log

Append a summary entry to `memory/progress_log.md`.

### Step 3: Update Change Log

If code changes were made, append entries to `memory/change_log.md`:
```markdown
### [date]
- **Issue**: [reference to active issue]
- **Files changed**: [list]
- **Summary**: [what changed and why]
```

### Step 4: Update Project State

Update `memory/project_state.md` with the current snapshot:
- Overall project status
- Active feature work
- Known risks or concerns
- Key metrics if applicable

### Step 5: Archive Previous Handoff

The previous `memory/session_handoff.md` content should be summarized and appended to `memory/progress_log.md` before being overwritten with the new handoff.

---

## Quality Checklist

Before considering the handoff complete:

- [ ] `memory/session_handoff.md` is written with all sections
- [ ] `memory/progress_log.md` is updated
- [ ] `memory/change_log.md` reflects all code changes
- [ ] `memory/recent_deltas.md` is current
- [ ] `active/active_context.md` reflects end-of-session state
- [ ] `active/active_issue.md` reflects current issue status
- [ ] Any discovered issues are in `memory/known_issues.md`

---

## Anti-Patterns

- Skipping the handoff because "we'll remember" -- you won't
- Writing vague next steps like "continue working on it" -- be specific
- Forgetting to mention blockers -- the next session will hit the same wall
- Not updating the active files -- the next session will read stale state
