# Melted Peak

**Engineering Context Operating System for Claude Code**

Melted Peak is a meta-framework that transforms Claude Code into a senior software engineer with persistent memory, accumulated skills, and disciplined engineering practices.

## The Problem

Every Claude Code session starts from zero. Context is lost between sessions, leading to:
- Repeated mistakes and circular problem-solving
- Forgotten architectural decisions
- Regression bugs from lost awareness of sensitive code areas
- Wasted time rebuilding context that already existed

## The Solution

Melted Peak provides a structured filesystem that Claude Code reads on startup to reconstruct working context, updates throughout a session to track progress, and writes to at session end to preserve state for the next session.

## How It Works

1. **CLAUDE.md** boots the system -- Claude Code reads it automatically and follows the boot sequence
2. **Context Compiler** selects the minimal relevant context for the current task
3. **Active Directory** holds the current working state (goal, issue, change plan)
4. **Memory Directory** stores continuity data (progress, decisions, handoffs)
5. **Frameworks, Skills, Knowledge** provide reusable engineering capabilities

## Directory Structure

```
Melted-Peak/
├── CLAUDE.md                    # AI agent bootloader and operating rules
├── README.md                    # This file
├── QUICKSTART.md                # Setup guide
├── docs/
│   ├── core/                    # System constitution and protocols
│   ├── registry/                # Component indexes
│   ├── templates/               # Standard file formats
│   ├── prompts/                 # Reusable workflow instructions
│   └── examples/                # Reference implementations
├── frameworks/                  # Large system frameworks
├── skills/                      # Reusable workflow capabilities
├── knowledge/                   # Reference material
├── peaks/                       # Importable domain sub-systems (frontend, backend, agents)
├── active/                      # Current working state (hot memory)
├── memory/                      # Continuity and progress (warm memory)
└── incoming/                    # Staging area for new components
```

## Design Philosophy

- **Context is king.** Every decision, change, and discovery is recorded
- **One issue at a time.** Focus prevents cascading errors
- **Plan before acting.** Change plans prevent unintended side effects
- **Verify before declaring done.** Regression prevention is non-negotiable
- **Minimal working context.** Load only what's needed, not everything
- **Leave a trail.** Every session ends with a handoff for the next

## System Components

| Component | Purpose |
|-----------|---------|
| **Core Protocols** | The rules that govern system behavior |
| **Context Compiler** | Selects relevant context for each task |
| **Active State** | Current goal, issue, change plan, validation |
| **Memory** | Progress log, decisions, handoffs, change history |
| **Frameworks** | Large reusable system frameworks |
| **Skills** | Small reusable workflow capabilities |
| **Knowledge** | Reference material and domain expertise |
| **Registry** | Index of all available components |
| **Readiness Gate** | Quality gate for new components |
| **Peaks** | Importable domain sub-systems (frontend, backend, agents) |
| **Metrics** | Effectiveness tracking, pattern detection, self-audit |

## Current Inventory

| Category | Count |
|----------|-------|
| Skills | 30 (28 core + 2 peak-provided) |
| Knowledge Packs | 4 (2 general + 2 peak-provided) |
| Protocols | 19 core docs |
| Peaks | 1 (modaf-saas -- full SaaS framework) |
| Prompts | 8 reusable workflow prompts |
| Templates | 9 standard formats |
| Examples | 4 filled-in reference examples |
| Total Files | 258+ |

See [docs/reference/skill_catalog.md](docs/reference/skill_catalog.md) for a complete skill guide organized by work phase and domain.

## Claude Code Native Integration

Melted Peak ships with full native Claude Code integration, making the entire system accessible through Claude Code's built-in extension points.

### Native Skills (`.claude/skills/`)

All Melted Peak commands are registered as native Claude Code skills. Type `/` in any session to see the full list. Every command from the [Key Commands](#key-commands) table -- `/boot`, `/handoff`, `/compile`, `/plan`, `/validate`, `/ingest`, `/issues`, `/kickoff`, `/new-skill`, `/retro`, `/audit`, `/peak` -- is implemented as a skill file and auto-discovered by Claude Code.

### Custom Agents (`.claude/agents/`)

Specialized subagent definitions for tasks that benefit from a focused, scoped persona:

| Agent | Purpose |
|-------|---------|
| **Auditor** | System self-audit -- verifies file integrity, registry consistency, protocol compliance |
| **Retrospective** | Post-completion analysis -- extracts lessons and feeds them back into the system |
| **Peak Ingestion** | Handles importing, normalizing, and mounting peaks from external sources |
| **Codebase Explorer** | Deep codebase analysis -- architecture mapping, dependency tracing, pattern detection |
| **Skill Creator** | Guided skill authoring -- interviews, scaffolds, validates, and registers new skills |

### Path-Scoped Rules (`.claude/rules/`)

Rules that auto-load when Claude Code edits files in specific directories. For example, editing files under `active/` automatically loads rules about context maintenance, while editing files under `frameworks/` loads rules about component structure and registry updates. No manual intervention required.

### Lifecycle Hooks (`.claude/settings.json`)

Comprehensive hooks automate context maintenance across the full session lifecycle:

| Hook | Trigger | Action |
|------|---------|--------|
| **SessionStart** | Session begins | Runs the boot sequence, loads active context and session handoff |
| **PreCompact** | Before context compaction | Preserves critical state so nothing is lost during compaction |
| **PostToolUse** | After file edits | Updates `recent_deltas.md` and checks the regression checklist |
| **Stop** | Agent completes a task | Updates `active_context.md` and `progress_log.md` |
| **SessionEnd** | Session ends | Executes the full handoff protocol automatically |

### Plugin Distribution (`.claude-plugin/plugin.json`)

Melted Peak can be loaded as a plugin in any project via `claude --plugin-dir /path/to/Melted-Peak`. This bundles the skills, agents, rules, and hooks so other repositories can use the full system without copying files.

### Headless Mode Integration

All Melted Peak workflows are compatible with `claude --headless` for CI/CD pipelines. Use headless mode to run automated audits, scheduled retrospectives, or regression checks as part of your build process.

### Agent Teams Integration

Melted Peak supports Claude Code's agent teams for parallel work. Multiple subagents can operate on different aspects of a task simultaneously while the system maintains coordination through the active state files.

### Worktree Support (`.worktreeinclude`)

The `.worktreeinclude` file declares which Melted Peak files should be shared across git worktrees, enabling parallel branch work with shared context and memory.

## Getting Started

See [QUICKSTART.md](QUICKSTART.md) for setup instructions.
