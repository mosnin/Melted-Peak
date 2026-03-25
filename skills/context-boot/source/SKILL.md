# Skill: Context Boot

## Purpose
Boot the Melted Peak context system at the start of a session. Ensures the AI agent has full awareness of current state, previous progress, and active work.

## Trigger
Execute at the beginning of every session, or when the user says `/boot`.

## Workflow

### Step 1: Read System Overview
Read `docs/core/00_system_overview.md` to establish system understanding.

### Step 2: Load Active State
Read these files in order:
1. `active/active_context.md` -- current goal and working state
2. `active/active_issue.md` -- current problem (skip if stub/empty)
3. `active/change_plan.md` -- planned changes (skip if stub/empty)
4. `active/validation_plan.md` -- verification steps (skip if stub/empty)

### Step 3: Load Session Handoff
Read `memory/session_handoff.md` to understand what the last session wants this session to know.

### Step 4: Assess Continuity
Determine if this is:
- **Fresh start**: No active context, no handoff -- await user task
- **Session resume**: Active context and handoff exist -- continue previous work
- **New task in existing project**: Active context exists but no active issue -- await user task with project awareness

### Step 5: Report Status
Summarize to the user:
- Current active goal (or "none")
- Current active issue (or "none")
- Last session summary (from handoff)
- Pending next steps (from handoff)
- Number of known issues (from `memory/known_issues.md`)

### Step 6: Compile Context (if resuming)
If continuing previous work, run the context compiler (`docs/core/02_context_compiler.md`) to load relevant frameworks, skills, and knowledge for the active task.

## Output
The agent is fully oriented with current state, previous context, and relevant components loaded. Ready to work.

## Error Handling
- If `active/active_context.md` is missing or empty: Report "no active context" and await task
- If `memory/session_handoff.md` is missing: Report "no previous session" and await task
- If referenced components are missing: Report the gap and continue with available context
