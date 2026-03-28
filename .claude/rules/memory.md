---
globs: "memory/**"
---

# Rules for Memory Files

- Memory files are append-only (except session_handoff.md which is replaced each session)
- Check rotation limits per `docs/core/04_memory_rotation_protocol.md` before appending
- Log all system modifications with `[system-self-improvement]` tag in change_log.md
- Never delete memory files -- archive or rotate them
- Resolved issues in known_issues.md should be moved to `memory/archive/resolved_issues.md`
- Architecture decisions use ADR format: context → options → decision → consequences
