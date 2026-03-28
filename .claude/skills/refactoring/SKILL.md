---
name: refactoring
description: Use when improving code structure without changing behavior — requires tests passing before and after, minimal scope
user-invocable: false
---

# Refactoring

**Before:** all tests must pass. Write change plan with scope. **During:** one refactoring type at a time, run tests after each change. **After:** verify all tests still green.

Do NOT add features during refactoring. If tests break, revert immediately.

See `skills/refactoring/source/SKILL.md` for full workflow.
