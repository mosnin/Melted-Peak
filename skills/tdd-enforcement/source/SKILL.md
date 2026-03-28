# TDD Enforcement

## Purpose

Enforce strict Test-Driven Development — write the failing test first, watch it fail, then write minimal code to pass it. No production code without a failing test first.

## Trigger

Before implementing any feature, fixing any bug, or writing any code that changes behavior.

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

**No exceptions:**
- Not "reference" code you'll add tests to later
- Not "exploratory" code you'll clean up
- Not "just this once" because the feature is small
- Not "I already manually tested it"

Delete means delete.

## RED-GREEN-REFACTOR Cycle

### RED — Write the failing test

Write ONE test describing the behavior you want:
- One behavior per test
- Clear test name: `test('rejects empty email', ...)`
- Tests real behavior, not mock internals

### Verify RED — Watch it fail

**MANDATORY. Never skip.**

Run the test. Confirm:
- It fails (not errors out)
- The failure message is expected
- It fails because the feature is missing (not a typo)

**Test passes?** You're testing existing behavior. Fix the test.

### GREEN — Minimal code

Write the simplest code that passes the test.
- No extra features beyond what the test requires
- No speculative generality (YAGNI)
- No refactoring other code while here

### Verify GREEN — Watch it pass

Run the full test suite. Confirm:
- New test passes
- No other tests broke
- No warnings introduced

### REFACTOR — Clean up

After green only:
- Remove duplication
- Improve names
- Extract helpers
- Do NOT add behavior

Keep tests green throughout.

## Why order matters

**"I'll write tests after to verify it works"**
Tests written after pass immediately. Passing immediately proves nothing — you never saw them catch a bug. Tests-first forces you to prove the test actually tests something.

**"Tests after achieve the same goals"**
Tests-after answer "what does this do?" Tests-first answer "what should this do?" Tests written after implementation are biased by what you built.

**"Deleting N hours of work is wasteful"**
Sunk cost fallacy. Keeping unverified code is the real waste — it will fail in production and cost more to debug.

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Too simple to need a test" | Simple code breaks too. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Already manually tested" | Ad-hoc ≠ systematic. Can't re-run when code changes. |
| "Tests after achieve same goals" | Tests-after = verify what you built. Tests-first = define what to build. |
| "Delete X hours of work? Wasteful" | Sunk cost fallacy. Unverified code is technical debt. |
| "Keep as reference while writing tests" | You'll adapt it. That's testing after. Delete means delete. |
| "Need to explore first" | Fine. Throw exploration away. Start fresh with TDD. |
| "Hard to test = unclear design" | Listen to the test. Hard to test = hard to use. Fix the design. |
| "TDD will slow me down" | TDD is faster than production debugging. |
| "Just this once" | No exceptions. |

## Red Flags — Stop and Delete

- Writing code before the test
- Test passes immediately without implementation
- "I'll write tests after confirming it works"
- Keeping code written before the test as "reference"
- "I don't fully understand yet, let me spike first" (OK, but throw the spike away)
- Adding multiple features in one RED-GREEN cycle

**All of these mean: Delete code. Start with a failing test.**

## Verification Checklist

Before marking any implementation complete:
- [ ] Every new function/method has a test written before it
- [ ] Watched each test fail before implementing
- [ ] Each test failed for the expected reason
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass after implementation
- [ ] No warnings introduced

Can't check all boxes? You skipped TDD. Start over.

## Integration

- **Before starting**: Check `active/change_plan.md` for the feature scope
- **After completing**: Run `active/validation_plan.md` and `active/regression_checklist.md`
- **Pairs with**: `skills/verification-before-completion/` — run after completing implementation
- **Pairs with**: `skills/debugging/` — bugs get a failing test before fixing
