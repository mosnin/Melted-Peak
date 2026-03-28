# Error Recovery Protocol

Defines how to handle failures, stuck states, and circular debugging. Most wasted effort comes from retrying failed approaches without understanding why they failed.

---

## The Three-Strike Rule

If you have tried **three different approaches** to solve the same problem and none have worked:

1. STOP attempting fixes
2. Update `active/active_issue.md` with all three attempts and their failure reasons
3. Write a **root cause analysis** section: what do the failures have in common?
4. Present the user with:
   - What you've tried
   - What you think the actual root cause is
   - Two or three fundamentally different strategies (not variations of what failed)
5. Wait for user direction before proceeding

## Before Every Fix Attempt

1. Read the `## Attempted Solutions` section of `active/active_issue.md`
2. Verify your proposed approach is NOT a variation of something already tried
3. If it IS similar, you must articulate what is fundamentally different this time
4. Write your approach to `## Attempted Solutions` BEFORE executing it

## Recognizing Circular Patterns

You are in a circular pattern if:
- You're reverting a change you made earlier in the same session
- You're re-applying a fix that was already attempted
- Error messages are cycling between two or three states
- You've been working on the same issue for more than 5 logical steps without progress

When you recognize a circle:
1. STOP
2. Update `active/active_issue.md` with the pattern you've observed
3. Step back and re-read the original problem description
4. Consider: is the problem actually what we think it is, or is the real problem elsewhere?

## Analysis Paralysis Detection

**Signal**: 5+ consecutive read operations (Read, Grep, Glob) without a single write action.

**What's happening**: The agent is stuck in an investigation loop, hoping the answer will appear from reading more files. This is a form of avoidance — reading feels productive but produces no output.

**Recovery**:
1. STOP reading
2. State what you know so far (write it to active/active_context.md Session Notes)
3. Form ONE hypothesis about the cause
4. Test it with the smallest possible change
5. If you can't form a hypothesis, escalate to the user with what you've found so far

**Prevention**:
- After every 3 reads, ask yourself: "Do I have enough to try something?"
- Set a mental budget: "I will read at most N files before acting"
- Prefer targeted reads (specific function, specific line) over full-file reads

## Error Escalation

| Situation | Action |
|-----------|--------|
| Fix works on first try | Log it, move on |
| Fix fails, root cause is clear | Update attempted solutions, try targeted fix |
| Fix fails, root cause is unclear | Investigate before attempting another fix |
| Three attempts failed | Stop, analyze, present options to user |
| Same error keeps recurring | The fix is likely in the wrong place -- investigate dependencies |
| Error moved (fixed here, broke there) | Regression -- follow regression prevention protocol |

## Post-Recovery

After resolving a difficult issue:
1. Update `active/regression_checklist.md` with the sensitive area
2. Update `memory/architecture_decisions.md` if a design insight was gained
3. Update `memory/known_issues.md` with related risks discovered
4. Write a brief "lessons learned" entry in the resolution section of `active/active_issue.md`
5. **Run the retrospective skill** if the issue took 2+ attempts. This feeds lessons back into the system so the same class of problem is handled better next time.
6. Log the pattern in `memory/metrics/pattern_journal.md` if the debugging approach could be reused
