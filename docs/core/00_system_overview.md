# System Overview

## What Is Melted Peak

Melted Peak is an Engineering Context Operating System. It is a structured filesystem that provides Claude Code with persistent memory, accumulated skills, and disciplined engineering practices across sessions.

It is not a software application. There is no runtime, build step, or executable code. The system is entirely composed of markdown and YAML files that Claude Code reads, follows, and updates.

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    CLAUDE.md                         │
│              (Bootloader / Entry Point)              │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌─────────────┐  ┌─────────────┐  ┌────────────┐  │
│  │  Context     │  │  Active     │  │  Memory    │  │
│  │  Compiler    │  │  State      │  │  System    │  │
│  │             │  │             │  │            │  │
│  │  Selects    │  │  Current    │  │  Progress  │  │
│  │  what to    │  │  goal,      │  │  log,      │  │
│  │  load       │  │  issue,     │  │  handoffs, │  │
│  │             │  │  plan       │  │  decisions │  │
│  └──────┬──────┘  └─────────────┘  └────────────┘  │
│         │                                           │
│  ┌──────▼──────────────────────────────────────┐    │
│  │           Component Library                  │    │
│  │  ┌────────────┐ ┌────────┐ ┌─────────────┐ │    │
│  │  │ Frameworks │ │ Skills │ │ Knowledge   │ │    │
│  │  └────────────┘ └────────┘ └─────────────┘ │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │          Core Protocols (docs/core/)         │    │
│  │  Operating principles, change control,       │    │
│  │  regression prevention, issue isolation      │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│  ┌─────────────┐  ┌─────────────┐                   │
│  │  Registry   │  │  Incoming   │                   │
│  │  (indexes)  │  │  (staging)  │                   │
│  └─────────────┘  └─────────────┘                   │
└─────────────────────────────────────────────────────┘
```

## Core Components

### CLAUDE.md (Bootloader)
The entry point. Read automatically by Claude Code on session start. Contains the boot sequence, operational rules, and user commands. Points to everything else.

### Context Compiler (`docs/core/02_context_compiler.md`)
The decision engine. Given a task, determines what frameworks, skills, knowledge, and protocols to load into working context. Prevents loading everything (wasteful) or nothing (blind).

### Active State (`active/`)
Hot memory. Read on every boot. Contains the current goal, current issue, change plan, and validation plan. Small, current, structured for instant comprehension. Overwritten each session.

### Memory System (`memory/`)
Warm memory. Read selectively. Accumulates over time. Contains progress logs, session handoffs, architecture decisions, change history, and known issues. The institutional memory of the project.

### Component Library (`frameworks/`, `skills/`, `knowledge/`)
Reusable engineering capabilities. Each component has three required files:
- **Source** -- the full content (documentation, workflow logic, reference material)
- **Manifest** (`manifest.yaml`) -- machine-readable metadata including dependencies and context cost
- **Summary** (`summary.md`) -- short operational overview for quick scanning

### Core Protocols (`docs/core/`)
The constitution. Defines how context is managed, how changes are planned, how regressions are prevented, how issues are isolated, and how sessions are handed off.

### Registry (`docs/registry/`)
Central index of all components. The context compiler uses these indexes to find relevant components for a task.

### Incoming (`incoming/`)
Staging area. New components land here first and must pass normalization and the readiness gate before being promoted to the component library.

## Glossary

| Term | Definition |
|------|-----------|
| **Framework** | A large system framework (e.g., testing strategy, API design patterns) |
| **Skill** | A reusable workflow capability (e.g., debugging protocol, code review checklist) |
| **Knowledge Pack** | Reference material for a domain (e.g., database optimization, auth patterns) |
| **Active Context** | The current working state: what we're doing, why, and what's next |
| **Context Compiler** | The process of selecting minimal relevant context for a task |
| **Session Handoff** | The protocol for preserving state between sessions |
| **Readiness Gate** | Quality gate that components must pass before use |
| **Hot Memory** | Files read every boot (`active/`) |
| **Warm Memory** | Files read selectively (`memory/`) |
| **Context Cost** | How much context window a component consumes (small/medium/large) |

## System Boundaries

Melted Peak manages **engineering context**. It does NOT:
- Execute code
- Run tests (it defines validation plans; the engineer runs the tests)
- Replace version control (it complements git, not replaces it)
- Make architectural decisions (it records them and provides context for making them)
