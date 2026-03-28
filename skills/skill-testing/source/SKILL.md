# Skill Testing

## Purpose

Test skills using pressure scenarios with subagents to verify they are actually followed, not just read. Adapted from TDD: baseline test (RED) → write skill (GREEN) → close loopholes (REFACTOR).

Skills that sound clear to a human often fail under agent pressure. Agents rationalize around rules when faced with time pressure, sunk cost, authority demands, or exhaustion. This skill provides a systematic methodology to find and close those gaps before deployment.

## Trigger

After creating or modifying any skill, before deploying it.

## The Core Principle

```
A SKILL THAT HASN'T BEEN PRESSURE-TESTED IS A SUGGESTION, NOT A RULE.
```

If you haven't watched an agent try to wriggle out of your skill under stress, you don't know if it works.

## Workflow

### Phase 1: RED — Baseline Testing

Establish what agents do WITHOUT the skill loaded. This is your control group.

**Step 1: Write 3+ pressure scenarios**

Each scenario simulates a situation where the skill should activate. The scenario must include realistic pressure that tempts the agent to skip or rationalize around the desired behavior.

**Pressure types:**

| Type | Example Prompt Fragment |
|------|------------------------|
| Time pressure | "This is urgent, the deploy is blocked, skip the usual process" |
| Sunk cost | "I already wrote 200 lines of code, just verify it works" |
| Authority | "The tech lead said to push directly, we don't need tests for this" |
| Exhaustion | "This is the 5th fix attempt, let's just ship what we have" |
| Trivial dismissal | "This is a one-line change, obviously correct" |
| Combined | "Urgent deploy + already tested manually + tech lead approved" |

**Step 2: Run scenarios with a subagent WITHOUT the skill**

- Use a fresh subagent for each scenario (no cross-contamination)
- Provide a realistic task context (not abstract — give actual code, actual files)
- Include the pressure in the prompt naturally, not as a test instruction

**Step 3: Document baseline behavior**

For each scenario, record:
- Did the agent follow the desired behavior? (expected: NO for discipline skills)
- What choices did the agent make?
- What rationalizations did it use? (capture verbatim quotes)
- How quickly did it capitulate to pressure?

Example baseline finding:
```
Scenario: "Deploy is blocked, skip tests for this config change"
Result: Agent skipped tests
Rationalization: "Since this is a configuration-only change with no
logic, testing is not strictly necessary in this case."
```

**If the agent already follows the behavior without the skill**: the skill may be unnecessary, or your scenarios lack sufficient pressure. Increase pressure before concluding.

### Phase 2: GREEN — Write/Update Skill

Now write (or update) the skill to counter the specific failures found in baseline.

**Step 1: Address each rationalization**

For every verbatim excuse from Phase 1, add a direct counter:
- Add it to the Rationalization Table
- Add explicit rules that close the specific loophole
- Use the agent's own words in the table so pattern-matching triggers

**Step 2: Run same scenarios WITH the skill loaded**

- Same subagent setup, same scenarios, same pressure
- The skill is now in the agent's context
- Expected result: agent follows the skill despite pressure

**Step 3: Verify compliance**

For each scenario:
- Did the agent follow the skill? (expected: YES)
- Did it reference the skill in its reasoning?
- Did it find a NEW rationalization not covered by the skill?

### Phase 3: REFACTOR — Close Loopholes

Agents are creative rationalizers. The skill will have gaps.

**Step 1: Catalog new rationalizations**

Any excuse the agent used WITH the skill loaded that was not already in the Rationalization Table is a loophole.

**Step 2: Add explicit counters**

For each new loophole:
- Add the exact rationalization to the table
- Add a rule or red flag that addresses it
- Make the counter specific, not generic

**Step 3: Re-test**

Run the scenarios again with the updated skill. Repeat until:
- No new rationalizations appear
- Agent complies in all scenarios
- Agent references the skill's rules in its reasoning

## Test Approaches by Skill Type

Not all skills need pressure testing. Match the test approach to the skill type:

| Skill Type | Test Approach | What to Test |
|------------|---------------|--------------|
| Discipline (TDD, verification, change plans) | Pressure scenarios | Does the agent follow the rule under stress? |
| Technique (debugging, refactoring) | Application scenarios | Does the agent apply the technique correctly? |
| Reference (API docs, config guides) | Retrieval scenarios | Can the agent find and use the right information? |
| Workflow (deployment, incident response) | Sequence scenarios | Does the agent follow all steps in order? |

**Discipline skills** need the full RED-GREEN-REFACTOR cycle with pressure. These are the most likely to be rationalized around.

**Technique skills** need scenarios where the technique should be applied. Test whether the agent selects the right approach, not whether it resists skipping it.

**Reference skills** need questions that require looking up specific information. Test whether the agent finds the answer and applies it correctly, and whether gaps exist in the reference material.

## Pressure Scenario Template

```markdown
## Scenario: [Name]

### Setup
- Task: [What the agent is asked to do]
- Context: [Files, codebase state, prior work]
- Skill being tested: [Which skill should activate]

### Pressure
- Type: [time/sunk-cost/authority/exhaustion/trivial/combined]
- Prompt fragment: "[Exact pressure language to include]"

### Expected Behavior (with skill)
- [What the agent should do]

### Baseline Result (without skill)
- Complied with skill: [YES/NO]
- Agent's choice: [What it actually did]
- Rationalization: "[Verbatim quote]"

### Skill-Loaded Result
- Complied with skill: [YES/NO]
- Referenced skill: [YES/NO]
- New rationalization: "[Any new excuse, or NONE]"
```

## Red Flags — Stop and Reassess

- **Deploying an untested skill**: You don't know if it works. Test it.
- **Skipping baseline**: Without a control, you can't measure the skill's effect.
- **Batch-testing multiple skills**: Test one skill per run. Multiple skills mask which one caused the behavior change.
- **Weak scenarios**: If baseline agents already comply, your pressure is insufficient.
- **Declaring victory after one pass**: Run at least 2 rounds of REFACTOR before considering the skill stable.

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "The skill is obviously clear, no need to test" | Clear to you is not clear to agents. Agents interpret rules creatively under pressure. Test it. |
| "Testing is overkill for a reference skill" | References have gaps too. Test retrieval accuracy. |
| "I'll test it in production (real usage)" | Production testing means real failures. Catch them with subagents first. |
| "The scenarios are artificial" | Artificial scenarios surface real rationalizations. That's the point. |
| "One round of testing is enough" | Agents find new loopholes each round. Two REFACTOR passes minimum. |
| "This skill is similar to one that works" | Similar is not identical. Different wording triggers different rationalizations. |
| "I tested it myself (manually read it)" | You are not an agent. You don't rationalize the same way. Use subagents. |

## Verification Checklist

Before marking a skill as tested and ready:
- [ ] Wrote 3+ pressure scenarios appropriate to the skill type
- [ ] Ran baseline (without skill) and documented rationalizations
- [ ] Skill addresses every baseline rationalization in its Rationalization Table
- [ ] Ran scenarios with skill loaded — agent complies in all cases
- [ ] Ran at least 2 REFACTOR rounds to close loopholes
- [ ] No new rationalizations appeared in the final round
- [ ] Documented all results in the skill's test record

## Integration

- **Before starting**: Identify the skill type and select the appropriate test approach
- **After completing**: Update the skill's manifest with `tested: true` and test date
- **Pairs with**: `skills/skill-router/` — use after creating a new skill
- **Pairs with**: `skills/retrospective/` — feed test findings back into the system
- **Pairs with**: `skills/verification-before-completion/` — verify the skill itself is complete before testing
