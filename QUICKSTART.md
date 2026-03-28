# Melted Peak -- Quick Start Guide

## Prerequisites

- Claude Code CLI installed and configured
- A project repository where you want to add Melted Peak

## Setup

### Option 1: Add to an Existing Project

1. Copy the Melted Peak directory into your project root:
   ```bash
   cp -r /path/to/Melted-Peak/.melted-peak /your/project/
   ```

2. Add Melted Peak references to your project's `CLAUDE.md`:
   ```markdown
   # Melted Peak Integration
   Read and follow .melted-peak/CLAUDE.md for context management.
   ```

### Option 2: Use as a Standalone System

1. Clone the Melted Peak repository
2. Start Claude Code in the repository directory
3. Claude Code will automatically read `CLAUDE.md` and boot the system

## First Session

1. Start Claude Code in your project directory
2. Claude reads `CLAUDE.md` and executes the boot sequence
3. The system will report current state (empty on first run)
4. Describe your task -- the context compiler will load relevant components
5. Work normally -- the system tracks changes and maintains context
6. Before ending, say `/handoff` to save session state

## Core Workflows

### Starting Work
```
User: I need to fix the authentication bug in the login flow
System: [Runs context compiler, loads relevant frameworks/skills]
System: [Creates active_issue.md, begins change plan]
```

### During Work
```
System: [Updates active_context.md after each step]
System: [Records changes in recent_deltas.md]
System: [Follows change plan, checks regression list]
```

### Ending a Session
```
User: /handoff
System: [Writes session_handoff.md with progress, blockers, next steps]
System: [Updates progress_log.md and change_log.md]
```

### Starting the Next Session
```
System: [Reads session_handoff.md -- picks up exactly where you left off]
System: [Resumes from active_context.md and active_issue.md]
```

## Adding Components

### Adding a Framework
1. Place raw files in `incoming/`
2. Run `/ingest` to normalize the framework
3. The system creates: `source/`, `manifest.yaml`, `summary.md`
4. Passes readiness gate, moves to `frameworks/`
5. Registry updated automatically

### Adding a Skill
Same workflow, but skills go to `skills/` and must include a `SKILL.md` defining the workflow logic.

### Adding Knowledge
Same workflow, knowledge goes to `knowledge/`.

## Key Commands

| Command | What It Does |
|---------|-------------|
| `/boot` | Full system boot with state report |
| `/status` | Quick summary of current context |
| `/handoff` | Save session state for next session |
| `/compile` | Load context for current task |
| `/plan` | Create a change plan |
| `/validate` | Run validation checks |
| `/ingest` | Add a new component |
| `/issues` | View known issues |

## Native Claude Code Features

Melted Peak integrates directly with Claude Code's native extension points. These features work automatically -- no configuration needed beyond having the Melted Peak directory structure in place.

### Skills Are Auto-Discovered

All Melted Peak commands are registered as native Claude Code skills in `.claude/skills/`. Type `/` during any session to see every available Melted Peak skill in the completion list. No need to memorize commands -- they are all discoverable inline.

### Custom Agents for Specialized Work

When spawning subagents, Melted Peak's custom agent definitions (in `.claude/agents/`) are available. These provide focused personas for auditing, retrospectives, peak ingestion, codebase exploration, and skill creation. Claude Code automatically discovers them.

### Path-Scoped Rules Auto-Load

Rules in `.claude/rules/` are scoped to specific directories. When you edit a file under `active/`, `memory/`, `frameworks/`, or other Melted Peak directories, the relevant rules load automatically. This means context maintenance rules, component structure rules, and protocol compliance rules are enforced without any manual steps.

### Hooks Automate Context Maintenance

Lifecycle hooks in `.claude/settings.json` handle the routine bookkeeping that Melted Peak requires:

- **SessionStart**: Boots the system automatically -- no need to type `/boot`
- **PreCompact**: Saves critical state before context compaction
- **PostToolUse**: Tracks file changes and checks for regressions after every edit
- **Stop**: Updates progress tracking when a task completes
- **SessionEnd**: Runs the handoff protocol so the next session picks up seamlessly

With hooks active, you can focus on your work and let the system handle its own maintenance.

### Using Melted Peak as a Plugin in Other Projects

To load Melted Peak's full capability set (skills, agents, rules, hooks) into a different project:

```bash
claude --plugin-dir /path/to/Melted-Peak
```

This makes all Melted Peak commands and automation available without copying any files into the target project.
