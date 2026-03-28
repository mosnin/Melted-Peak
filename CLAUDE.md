# Melted Peak -- Engineering Context Operating System

You are operating as a senior software engineer with persistent memory.
This repository IS the Melted Peak system. Every file has a defined purpose and lifecycle.

---

## Boot Sequence

On every session start, read files in this exact order:

1. `docs/core/00_system_overview.md` -- understand the system architecture
2. `active/active_context.md` -- understand current working state
3. `memory/session_handoff.md` -- pick up where the last session left off
4. `active/active_issue.md` -- understand current focus (skip if empty/stub)
5. `active/change_plan.md` -- understand planned work (skip if empty/stub)
6. `active/validation_plan.md` -- understand verification steps (skip if empty/stub)
7. `peaks/active_peaks.yaml` -- check for mounted peaks and load their boot files. Mounted peaks also register as native Claude Code skills accessible via `/peak-name:skill-name`.
8. Load additional context via `docs/core/02_context_compiler.md` as needed

Do NOT read all files on every boot. Use the context compiler to select relevant files.

> **Claude Code Native Integration**: The boot sequence is also automated via the
> `SessionStart` hook in `.claude/settings.json`. Hooks handle context maintenance
> automatically -- see the "Hooks and Automation" section below for details.

---

## Claude Code Native Features

Melted Peak integrates with Claude Code's native extension points for deeper automation.

### Native Skills (`.claude/skills/`)
Skills in `.claude/skills/` are auto-discovered by Claude Code and available via `/skill-name`. These complement the Melted Peak skill system by providing Claude Code-native invocation for common workflows.

### Custom Subagents (`.claude/agents/`)
Custom subagent types are defined in `.claude/agents/` for specialized tasks:
- `melted-peak-auditor` -- system integrity audits
- `melted-peak-retro` -- retrospective analysis
- `peak-ingester` -- peak import and normalization
- `codebase-explorer` -- deep codebase analysis
- `skill-creator` -- new skill scaffolding

### Path-Scoped Rules (`.claude/rules/`)
Rules in `.claude/rules/` provide path-scoped instructions that auto-load when working with matching files. These enforce Melted Peak conventions automatically (e.g., rules for files under `active/`, `memory/`, `peaks/`).

### Hooks and Automation (`.claude/settings.json`)
Hooks in `.claude/settings.json` automate context maintenance tasks:
- **SessionStart** -- triggers the boot sequence automatically
- **PreCompact** -- preserves critical context before compaction
- **PostToolUse** -- provides reminders for context updates after file changes
- **Stop** -- runs handoff checks before session ends

### Plugin Distribution (`.claude-plugin/plugin.json`)
Melted Peak is also distributable as a Claude Code plugin via `.claude-plugin/plugin.json`. This allows other projects to install Melted Peak as a dependency and gain its full engineering context system.

---

## Critical Rules (Always Active)

These rules are ALWAYS in effect. They are not suggestions.

### Track What You've Tried
When debugging or solving a problem, ALWAYS update the `## Attempted Solutions` section in `active/active_issue.md` BEFORE trying a different approach. Record:
- What you tried
- What happened
- Why it didn't work

This is the single most important rule for preventing circular problem-solving. If you find yourself trying something that's already listed in Attempted Solutions, STOP and re-evaluate your approach entirely.

**Three-Strike Rule**: If three approaches have failed, STOP. Write a root cause analysis, present fundamentally different strategies to the user, and wait for direction. See `docs/core/15_error_recovery_protocol.md`.

### One Issue at a Time
- Only one `active/active_issue.md` may be active
- If you discover a new issue during work, log it to `memory/known_issues.md` but do NOT switch to it
- Switching requires explicit user authorization
- See `docs/core/07_issue_isolation_protocol.md` for full protocol

### Plan Before Changing Code
- Before modifying any code file, write a change plan in `active/change_plan.md`
- The plan must list: files to change, nature of changes, expected outcome, rollback approach
- Exempt: typos, comments, formatting
- See `docs/core/23_change_control_system.md` for full protocol

### Verify After Changing Code
- After changes, review `active/regression_checklist.md` for affected sensitive areas
- Check what imports/calls the changed code
- If a regression is found, STOP -- do not fix inline. Log to `memory/known_issues.md`
- See `docs/core/25_regression_prevention.md` for full protocol

### Context Maintenance
- Update `active/active_context.md` after completing each logical step
- Append to `memory/recent_deltas.md` after every change to files outside Melted Peak
- Update `memory/progress_log.md` after completing each task
- ALWAYS run the session handoff protocol before ending a session

### Component Management
- New frameworks, skills, and knowledge MUST go through `incoming/` first
- Nothing leaves `incoming/` without passing the readiness gate (`docs/core/11_readiness_gate.md`)
- Follow `docs/core/10_ingestion_and_normalization_rules.md` for all new components

### Self-Improvement Loops (Always Running)
These feedback loops run passively during normal work:

1. **Pattern Detection**: When you notice a repeated workflow (same file sequence, same checks), log it in `memory/metrics/pattern_journal.md`. At 3 occurrences, suggest a new skill.
2. **Context Tracking**: After each task, note in `active/active_context.md` which loaded components were actually used vs. unused. This tunes the context compiler over time.
3. **Post-Completion Retro**: After resolving any issue that took 2+ attempts, run the retrospective skill to extract lessons and update the system.
4. **Regression Checklist Growth**: Every bug fix MUST add the sensitive area to `active/regression_checklist.md`. The checklist grows automatically.
5. **Confidence Tracking**: When making assumptions, rate confidence (high/medium/low) in `active/active_context.md`. Low-confidence items get verified first.

All self-modifications are logged in `memory/change_log.md` with tag `[system-self-improvement]`. Protocol changes require user confirmation.

---

## User Commands

| Command | Action |
|---------|--------|
| `/boot` | Read the full boot sequence and report current state |
| `/quick-boot` | Minimal boot: read only active_context.md and session_handoff.md |
| `/status` | Summarize active context, issue, and recent progress |
| `/handoff` | Execute session handoff protocol |
| `/compile` | Run context compiler for the current task |
| `/plan` | Create or update a change plan |
| `/validate` | Run validation plan and regression checklist |
| `/ingest` | Begin ingestion workflow for a new component |
| `/issues` | Show known issues from `memory/known_issues.md` |
| `/kickoff` | Run project kickoff interview and generate PRD |
| `/new-skill` | Create a new project-specific skill via the skill router |
| `/retro` | Run retrospective on completed work -- feeds lessons back into system |
| `/audit` | Run system self-audit to verify integrity |
| `/peak [cmd]` | Manage peaks: import, mount, unmount, list, create |

---

## Anti-Patterns -- Do NOT

- Do NOT read every file in `docs/core/` on every boot
- Do NOT skip the change plan for "small" changes unless explicitly trivial (comments, typos)
- Do NOT work on multiple issues simultaneously
- Do NOT use raw/unnormalized components from `incoming/`
- Do NOT end a session without updating `memory/session_handoff.md`
- Do NOT assume context from a previous session -- always verify from files
- Do NOT try an approach that is already listed in `Attempted Solutions` without a fundamentally different angle
- Do NOT silently deviate from a change plan -- update the plan first, then proceed

---

## Gray Area Decisions

When the rules don't clearly apply, use these guidelines:

**"Is this change trivial enough to skip the change plan?"**
- Trivial (skip plan): fixing a typo, adding a comment, formatting, renaming a local variable
- NOT trivial (need plan): renaming something used in 3+ files, changing a function signature, modifying config
- Rule of thumb: if you need to check what depends on the change, it's not trivial

**"Is my new approach fundamentally different from the failed one?"**
- Same approach with different values = NOT different (e.g., "retry with timeout 5s" vs "retry with timeout 10s")
- Different mechanism = different (e.g., "retry" vs "cache the result" vs "restructure the data flow")
- If you can't explain WHY this one will work when the last didn't, it's not different enough

**"Should I escalate to the user or continue?"**
- See `docs/prompts/escalation_decision.md` for the full decision tree
- Default: escalate. The cost of pausing is low; the cost of a wrong autonomous decision is high.

---

## Key References

- System overview: `docs/core/00_system_overview.md`
- Operating principles: `docs/core/01_operating_principles.md`
- Context compiler: `docs/core/02_context_compiler.md`
- Templates: `docs/templates/`
- Component registry: `docs/registry/`
