---
name: handoff
description: Execute the session handoff protocol — write progress, blockers, decisions, and next steps to memory files before ending the session
user-invocable: true
---

# /handoff — Session Handoff

Execute `docs/core/06_session_handoff_protocol.md` fully:

1. Update `active/active_context.md` with final state
2. Write `memory/session_handoff.md`: what was accomplished, blockers, decisions made, exact next steps
3. Append to `memory/progress_log.md`
4. Update `memory/change_log.md` with any system changes
5. Check `active/active_issue.md` — ensure Attempted Solutions is current
6. Verify no uncommitted changes (warn if present)
