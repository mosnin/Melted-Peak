# Context Boot -- Summary

Boots the Melted Peak context system at session start. Reads active state, session handoff, and previous progress to fully orient the AI agent before work begins.

## When to Use
- At the start of every session
- When the user says `/boot`
- After a long pause where context may have degraded

## Key Steps
1. Read system overview for orientation
2. Load active state (context, issue, plans)
3. Load session handoff from previous session
4. Assess continuity (fresh start vs. resume vs. new task)
5. Report status to user
6. Compile additional context if resuming work

## Dependencies
None -- this is the foundational skill.

## Context Cost
Small -- reads only active state and handoff files on boot. Additional context is loaded on demand via the context compiler.
