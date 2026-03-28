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
- All entries in recent_deltas.md, progress_log.md, and change_log.md MUST use the observation taxonomy format from `docs/core/26_observation_taxonomy.md`
- Include type tag `[bugfix|feature|refactor|change|discovery|decision]` in every entry header
- Include 1-3 concept tags (#how-it-works, #problem-solution, #gotcha, #pattern, etc.) per entry
