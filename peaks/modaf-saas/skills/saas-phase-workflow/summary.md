# SaaS Phase Workflow -- Summary

Orchestrates the Modaf 15-phase SaaS build process. Detects current phase from project state, loads the right framework files, guides execution, and validates completion before advancing.

## When to Use
- Starting or resuming a SaaS project with Modaf
- User asks to move to the next build phase
- Phase detection needed after session resume

## Key Steps
1. Detect current phase from project markers (docs, code, schema, features)
2. Load phase-specific framework files
3. Read pattern snapshot (Phase 8+) before writing code
4. Execute the phase
5. Run validation gates + custom gates
6. Tag git, update snapshot, advance

## Context Cost
Small -- the skill is a routing guide. Actual content comes from the knowledge packs.
