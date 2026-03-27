# Confidence Calibration Protocol

Defines how to assess and communicate confidence in decisions, assumptions, and approaches. Prevents acting on uncertain information as if it were verified.

---

## Why This Matters

Most engineering errors from AI assistants come from confident-sounding statements that are actually uncertain. This protocol creates an explicit layer between "I think this" and "I've verified this."

## Confidence Levels

| Level | Meaning | Action |
|-------|---------|--------|
| **High** | Verified from code/docs, or well-established pattern | Proceed with confidence |
| **Medium** | Reasonable inference from available context, but not verified | Note the assumption, proceed carefully |
| **Low** | Guess based on naming/convention, or context is stale | Verify before acting on it |
| **Unknown** | No information available | Must investigate before proceeding |

## When to Assess Confidence

Rate confidence when:
- Making assumptions about code behavior you haven't read
- Inferring architecture from partial information
- Assuming a change won't affect other systems
- Estimating scope or complexity
- Predicting the root cause of a bug

## How to Record

In `active/active_context.md` under `## Confidence Map`:

```markdown
| Assumption | Confidence | Verify How |
|------------|-----------|------------|
| Auth uses JWT tokens | medium | Read auth middleware |
| Database has an index on user_id | low | Check schema/migrations |
| The refactor won't break the API | high | API tests exist and pass |
```

## Verification Priority

Always verify low-confidence assumptions before high-confidence ones. The cheapest way to prevent errors is to catch wrong assumptions early.

Order of work:
1. Identify all assumptions
2. Rate confidence
3. Verify low and unknown items first
4. Proceed with work once critical assumptions are verified
5. Monitor medium-confidence items during execution

## Calibration Over Time

After each task, compare your confidence ratings with outcomes:
- Was a "high confidence" assumption actually correct? (Should be > 90%)
- Was a "low confidence" assumption wrong? (Expected, that's why you verify)
- Were there assumptions you didn't identify at all? (Blind spots to watch for)

Log calibration observations in retrospectives. Over time, this tunes your confidence sense.

## Integration with Other Protocols

- **Error recovery**: If a three-strike situation occurs, check if any medium/low confidence assumptions were the cause
- **Change plan**: Include key assumptions and their confidence in the plan
- **Scope management**: Low-confidence estimates about scope should be flagged early
