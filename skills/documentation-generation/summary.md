# Documentation Generation -- Summary

Structured workflows for creating and maintaining project documentation. Covers the full lifecycle: deciding what to document, generating it in the right format, and keeping it accurate over time.

## When to Use
- A project or feature needs a README, API docs, or user guide
- An architectural decision needs recording (ADR)
- A release needs a changelog or migration guide
- Code needs docstrings, annotations, or inline comments
- Contributing guidelines need creation or updating
- Existing documentation may be stale and needs review

## Documentation Types Covered
1. **READMEs** -- project overview, quick start, setup, usage, structure
2. **API docs** -- auto-generated from code annotations, OpenAPI specs, examples
3. **ADRs** -- architecture decision records with status, context, decision, consequences
4. **Changelogs** -- user-facing release notes from conventional commits
5. **Code docs** -- when and how to write comments, docstrings, JSDoc/TSDoc
6. **User guides** -- progressive tutorials with verification steps
7. **Contributing guidelines** -- PR process, code standards, testing expectations

## Key Principles
- Document **why**, not what -- code already says what
- Single source of truth -- never duplicate information across docs
- Docs are code -- they live in the repo, get reviewed in PRs, and go stale if ignored
- Know when NOT to document -- self-evident code, internal details, and ephemeral decisions do not need docs

## Melted Peak Integration
Feeds into and reads from `change_log`, `architecture_decisions`, `feature_registry`, and `active_context`. Logs documentation gaps to `known_issues`.

## Context Cost
Small -- workflow guide only.
