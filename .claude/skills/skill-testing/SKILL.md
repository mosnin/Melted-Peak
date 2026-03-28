---
name: skill-testing
description: Use after creating or modifying any skill, before deploying it — tests with pressure scenarios to verify agents actually follow the skill under stress
user-invocable: false
---

# Skill Testing

**Principle:** A skill that hasn't been pressure-tested is a suggestion, not a rule.

**RED-GREEN-REFACTOR for skills:**

1. **RED — Baseline:** Write 3+ pressure scenarios. Run with subagent WITHOUT the skill. Document rationalizations verbatim.
2. **GREEN — Load Skill:** Run same scenarios WITH the skill. Agent should comply in all cases.
3. **REFACTOR — Close Loopholes:** Catalog new rationalizations found with skill loaded. Add counters to the Rationalization Table. Re-test. Repeat 2+ rounds until no new excuses appear.

**Pressure types:** time ("this is urgent"), sunk cost ("already wrote the code"), authority ("manager approved"), exhaustion ("5th fix attempt"), trivial ("one-line change"), combined.

**Test approach by skill type:**

| Type | Approach |
|------|----------|
| Discipline (TDD, verification) | Pressure scenarios |
| Technique (debugging, refactoring) | Application scenarios |
| Reference (API docs) | Retrieval scenarios |

**Red Flags:**
- Deploying untested skills
- Skipping baseline (no control group)
- Batch-testing multiple skills
- Declaring victory after one pass

**Rationalization Table:**

| Excuse | Reality |
|--------|---------|
| "Skill is obviously clear" | Clear to you, not to agents. Test it. |
| "Testing overkill for reference" | References have gaps. Test retrieval. |
| "I'll test in production" | Production = real failures. Subagents first. |
| "One round is enough" | Agents find new loopholes each round. |

See `skills/skill-testing/source/SKILL.md` for full detail.
