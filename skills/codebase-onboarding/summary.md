# Codebase Onboarding -- Summary

Structured workflow for learning an unfamiliar codebase from scratch. Produces an architecture map, convention guide, regression checklist entries, and a durable mental model for future sessions.

## When to Use
- First time working in a new codebase
- After a major rewrite or architectural overhaul
- When context about the codebase feels thin or unreliable

## Key Phases
1. **First Contact** -- README, directory structure, package manifest, config files
2. **Architecture Mapping** -- entry points, data flow, key abstractions, dependency graph
3. **Convention Discovery** -- naming, error handling, state management, testing patterns
4. **Guided Exploration** -- hot paths, end-to-end request trace, shared utilities
5. **Sensitive Area Identification** -- fragile code, untested code, complex logic (feeds regression checklist)
6. **Mental Model Creation** -- synthesize a summary of how the system works for future sessions

## Integration
- Implements and extends the knowledge extraction protocol (`docs/core/12_knowledge_extraction_protocol.md`)
- Populates `active/regression_checklist.md` with sensitive areas
- Writes architecture map to `memory/architecture_decisions.md`
- Writes orientation, conventions, and mental model to `active/active_context.md`

## Context Cost
Small -- workflow guide only.
