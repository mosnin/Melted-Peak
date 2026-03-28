---
name: retro
description: Run a retrospective on completed work — extracts lessons, updates skills, tunes context profiles, logs metrics
user-invocable: true
---

# /retro — Retrospective

Launch the `melted-peak-retro` subagent:

1. Review resolved issue, attempted solutions, what worked
2. Extract lessons: patterns to repeat, patterns to avoid
3. Check pattern_journal.md for 3+ occurrences → suggest new skill
4. Update `memory/metrics/retrospectives.md`
5. Suggest system improvements if gaps found

Run after any issue that took 2+ attempts.

**Forensics Mode:** Use when a workflow failed or got stuck (stale handoff, 3+ failed attempts, abandoned plan). Examines git history + state files to diagnose root cause. Run with `/retro --forensics` or when forensics triggers are detected.
