# Regression Prevention

Defines how to prevent new bugs during changes. A regression is when a change breaks something that previously worked.

---

## Why Regressions Happen

1. **Lost context**: The engineer didn't know about a dependency or sensitive area
2. **Scope bleed**: Changes expanded beyond the plan without re-evaluation
3. **Untested paths**: The change was tested for the happy path but not edge cases
4. **Silent failures**: The change broke something that isn't immediately visible

Melted Peak addresses all four through structured prevention.

## The Regression Checklist

`active/regression_checklist.md` is a living document that grows as the project matures. It tracks known sensitive areas -- code, config, or behavior that is fragile or has broken before.

### Checklist Entry Format
```markdown
### [area name]
- **Files**: [file paths]
- **Why sensitive**: [what makes this fragile]
- **How to verify**: [specific check to confirm it still works]
- **Last verified**: [date]
- **Added because**: [what regression led to adding this entry]
```

## Verification Workflow

After every change:

### Step 1: Review the Checklist
Read `active/regression_checklist.md`. For each entry:
- Is this area affected by the current change?
- If yes, run the verification steps listed

### Step 2: Check Adjacent Systems
Look at what depends on the changed files:
- Imports: What imports the changed file?
- Consumers: What calls the changed functions?
- Config: Does anything read the changed config values?

### Step 3: Run Validation Plan
Execute `active/validation_plan.md`:
- Positive tests (does the change work?)
- Negative tests (do error cases still work?)
- Boundary tests (do edge cases still work?)
- Integration tests (do connected systems still work?)

### Step 4: Update the Checklist
If the change introduced a new sensitive area, add it to the checklist:
- What's sensitive about it?
- How to verify it in the future?
- Why was it added?

### Step 5: Record Results
Update `memory/recent_deltas.md` with verification outcomes.

---

## Prevention Techniques

### Before Writing Code
- Read the change plan
- Read the regression checklist
- Identify affected files and their dependents

### While Writing Code
- Make one logical change at a time
- Verify after each logical change, not just at the end
- If something unexpected happens, stop and investigate before continuing

### After Writing Code
- Run the full verification workflow above
- If a regression is found: STOP. Do not attempt to fix it inline.
- File the regression as a new issue in `memory/known_issues.md`
- Revert the change if the regression is severe
- Inform the user before proceeding

---

## Regression Response Protocol

If a regression is detected:

1. **Document it** in `memory/known_issues.md` with full details
2. **Assess severity**: Does it block current work? Is it user-facing?
3. **Decide action**:
   - **Revert** if the regression is severe and the fix is unclear
   - **Fix forward** if the regression is minor and the fix is obvious
   - **Pause and plan** if the regression is complex -- create a new change plan
4. **Update the regression checklist** to prevent recurrence
