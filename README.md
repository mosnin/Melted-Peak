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

## Getting Started

See [QUICKSTART.md](QUICKSTART.md) for setup instructions.
