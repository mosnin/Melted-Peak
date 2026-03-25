# System Overview

Melted Peak is an Engineering Context Operating System -- a structured filesystem that gives Claude Code persistent memory across sessions. It is markdown and YAML files, not software.

## Quick Reference

| Directory | Role | When Read |
|-----------|------|-----------|
| `active/` | Hot memory: current goal, issue, plan, validation | Every boot |
| `memory/` | Warm memory: progress, handoffs, decisions, history | Selectively |
| `frameworks/` | Large reusable frameworks | Via context compiler |
| `skills/` | Small reusable workflows | Via context compiler |
| `knowledge/` | Reference material | Via context compiler |
| `docs/core/` | System protocols (change control, regression, etc.) | When relevant |
| `docs/registry/` | Component indexes | During context compilation |
| `docs/templates/` | Standard file formats | When creating artifacts |
| `incoming/` | Staging for new components | During ingestion |

## Component Structure

Every framework, skill, and knowledge pack has three files:
- **Source** -- full content (docs, workflow logic, reference material)
- **Manifest** (`manifest.yaml`) -- metadata: name, status, context_cost, dependencies, tags
- **Summary** (`summary.md`) -- short overview readable in 60 seconds

## Key Concepts

- **Context Compiler** (`docs/core/02_context_compiler.md`): Selects minimal relevant context for a task. Uses work-type profiles (bug-fix, new-feature, refactor, etc.)
- **Context Cost**: Each component declares `small` / `medium` / `large` in its manifest. The compiler uses this to avoid overloading the context window.
- **Readiness Gate** (`docs/core/11_readiness_gate.md`): Components must have status `ready` before use. Draft/deprecated components are blocked.
- **Session Handoff** (`docs/core/06_session_handoff_protocol.md`): End-of-session protocol that writes progress, blockers, and next steps to `memory/session_handoff.md`.

## System Boundaries

Melted Peak manages engineering context. It does NOT execute code, run tests, replace git, or make decisions -- it records and provides context for all of these.

## Full Reference

For architecture diagrams and glossary, see `docs/reference/full_system_overview.md`.
