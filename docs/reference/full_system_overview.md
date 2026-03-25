# Full System Overview (Reference)

This is the detailed reference version. The condensed version at `docs/core/00_system_overview.md` is what gets read on boot.

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
