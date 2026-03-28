# Skill: Debugging

## Purpose
Systematic approach to diagnosing and fixing bugs that prevents circular debugging and ensures root causes are found, not just symptoms treated.

## Trigger
- User reports a bug or unexpected behavior
- A test failure is discovered
- A regression is detected
- Context compiler selects work type `bug-fix`

## Workflow

### Phase 1: Characterize (before touching code)

1. **Write the issue** to `active/active_issue.md`:
   - Title: descriptive, specific
   - Description: what's wrong, in precise terms
   - Expected vs. actual behavior
   - Steps to reproduce (if known)
   - Severity: critical | high | medium | low

2. **Check known issues** -- read `memory/known_issues.md`:
   - Has this been seen before?
   - Is there a related issue with notes?

3. **Check recent changes** -- read `memory/recent_deltas.md`:
   - Was anything changed recently that could cause this?
   - If yes, that's your first investigation target

4. **Reproduce the bug**:
   - Can you trigger it reliably?
   - What are the exact conditions?
   - If you can't reproduce it, document what you tried

### Phase 2: Isolate

5. **Form a hypothesis**:
   - Based on symptoms, where is the most likely cause?
   - Write the hypothesis in `active/active_issue.md` under Notes

6. **Narrow the scope**:
   - Read the suspected file(s)
   - Trace the data flow: input → processing → output
   - Find where actual behavior diverges from expected

7. **Verify the root cause**:
   - Can you explain WHY the bug occurs, not just WHERE?
   - If you can only identify WHERE but not WHY, dig deeper
   - A root cause explains the mechanism, not just the location

### Phase 3: Fix

8. **Write a change plan** in `active/change_plan.md`:
   - What file(s) to change
   - What the fix is and why it addresses the root cause
   - What could go wrong (risk assessment)
   - How to verify the fix

9. **Log the attempt** in `active/active_issue.md` under `## Attempted Solutions`:
   ```
   ### Attempt N
   - **Approach**: [what you're about to try]
   - **Hypothesis**: [why you think this will work]
   - **Result**: [fill in after]
   - **Why it failed**: [fill in if it failed]
   ```

10. **Implement the fix**:
    - Make the minimal change needed
    - Do NOT refactor surrounding code
    - Do NOT fix adjacent issues

11. **Verify the fix**:
    - Does the bug reproduce? (should be no)
    - Do related tests pass?
    - Check `active/regression_checklist.md` for affected areas

### Phase 4: Harden

12. **Update the regression checklist**:
    - Add the bug's location as a sensitive area
    - Document how to verify it in the future

13. **Close the issue**:
    - Fill in the Resolution section of `active/active_issue.md`
    - Update `memory/progress_log.md`
    - Update `memory/change_log.md`

## Critical Rules

- **NEVER skip Phase 1.** Understanding the bug before fixing it prevents misdiagnosis.
- **ALWAYS log attempts** before trying them. This is the firewall against circular debugging.
- **Three-strike rule**: If three fix attempts fail, STOP. Read all three failure reasons. Write a root cause analysis. Present fundamentally different strategies to the user.
- **One bug at a time.** If you find another bug while debugging, log it to `memory/known_issues.md` and continue with the original.
- **Minimal fix.** The fix should address the root cause and nothing else. Resist the urge to "improve" nearby code.

## Red Flags — Stop and Re-Diagnose

If you catch yourself thinking any of these, return to Phase 1:

- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "It's probably X, let me fix that" (without verifying)
- "One more fix attempt" (when you've already tried 2+)
- "I don't fully understand but this might work"
- Each fix reveals a new problem in a different place (architectural problem, not a bug)

**Three or more fixes failed?** Stop entirely. Question the architecture. Present fundamentally different strategies to the user before trying anything else.

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Issue is simple, no need to characterize" | Simple bugs have root causes too. Skipping Phase 1 causes misdiagnosis. |
| "Emergency, no time for process" | Systematic debugging is faster than thrashing. Process saves time. |
| "Just try this first, then investigate" | First attempt sets the pattern. Do it right from the start. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |
| "Multiple changes at once saves time" | You won't know which change fixed it. Causes new bugs. |
| "One more fix attempt" (after 2 failures) | Three failures = architectural problem. Escalate. |

## Anti-Patterns

- Jumping to fix without reproducing — you might fix the wrong thing
- Changing multiple things at once — you won't know which change fixed it
- Reverting to "try something else" without understanding why the last thing failed
- Fixing symptoms instead of root cause — the bug will return in a different form
- Expanding scope during debugging — "while I'm here" changes create new bugs
