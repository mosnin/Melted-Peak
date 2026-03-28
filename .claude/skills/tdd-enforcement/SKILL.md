---
name: tdd-enforcement
description: Use when implementing any feature, fixing any bug, or writing code that changes behavior — before touching production code
user-invocable: false
---

# TDD Enforcement

**The Iron Law:** NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST

Write code before test? Delete it. Start over.

**RED-GREEN-REFACTOR:**
1. **RED** — Write ONE failing test. Watch it fail (mandatory).
2. **GREEN** — Write minimal code to pass. No extras.
3. **REFACTOR** — Clean up while keeping green.

**Red Flags — Delete and Start Over:**
- Writing code before test
- Test passes immediately without implementation
- "I'll test after confirming it works"
- Keeping pre-test code as "reference"

**Rationalization Table:**

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Test takes 30 seconds. |
| "Tests after = same goals" | Tests-after verify what you built. Tests-first define what to build. |
| "Already manually tested" | Manual can't be re-run. |
| "Just this once" | No exceptions. |

See `skills/tdd-enforcement/source/SKILL.md` for full detail.
