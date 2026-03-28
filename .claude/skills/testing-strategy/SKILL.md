---
name: testing-strategy
description: Use when designing a test plan — deciding what to test, what type (unit/integration/e2e), what to mock, and what coverage matters
user-invocable: false
---

# Testing Strategy

**Test pyramid:** Unit (many, fast) → Integration (fewer, cross-component) → E2E (minimal, full-stack)

**What to test:** happy path, edge cases, error paths. **Not:** implementation details, third-party libs, framework internals.

**Mocking:** at boundaries only (external services, filesystem, time). For strict TDD: see `skills/tdd-enforcement/`.

See `skills/testing-strategy/source/SKILL.md` for full workflow.
