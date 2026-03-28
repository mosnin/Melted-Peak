# Verification Before Completion

## Purpose

Ensure claims of completion, success, or correctness are always backed by fresh evidence — not assumptions, cached results, or wishful thinking.

## Trigger

Before ANY of these:
- Marking a task, issue, or fix as done
- Claiming tests pass, linter is clean, or build succeeds
- Committing, creating a PR, or declaring a feature complete
- Moving on to the next task

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in THIS message, you cannot claim it passes.

## Workflow

### Step 1: Identify the verification command

What command proves the claim you're about to make?

| Claim | Required Evidence |
|-------|------------------|
| "Tests pass" | Run test suite, see 0 failures |
| "Linter clean" | Run linter, see 0 errors |
| "Build succeeds" | Run build, see exit 0 |
| "Bug fixed" | Test original symptom: passes |
| "Requirements met" | Re-read spec, check each requirement |
| "Agent completed work" | Check git diff, verify actual changes |
| "No regressions" | Run regression checklist |

### Step 2: Run the full command fresh

- Full command, not partial
- Fresh run, not cached output
- This message, not a previous run

### Step 3: Read the complete output

- Exit code
- Pass/fail counts
- Error messages

### Step 4: State the actual result with evidence

Good: "Tests: 47/47 pass (0 failures)"
Bad: "Tests should pass now"
Bad: "Looks correct"

### Step 5: ONLY THEN make the claim

## Red Flags — Stop and Verify

If you notice yourself about to:
- Use "should", "probably", "seems to", "looks like"
- Express satisfaction before running anything ("Done!", "Perfect!", "All good!")
- Commit or close a task without running anything
- Trust an agent's self-report without checking the diff
- Run a partial check and extrapolate to full pass

**Stop. Run the verification. Then claim the result.**

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Should work now" | Run the verification |
| "I'm confident it's right" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed so build will too" | Linter ≠ compiler |
| "The agent said it succeeded" | Verify independently — check the diff |
| "I'm tired, it looks fine" | Exhaustion is not a verification method |
| "Partial check is close enough" | Partial proves nothing |
| "Previous run still applies" | Fresh run required |

## Integration

- **Relates to**: `docs/core/25_regression_prevention.md`
- **Pairs with**: `active/validation_plan.md` — run the plan before declaring done
- **Hook**: The PostToolUse hook reminds you to verify after file changes

## 4-Level Artifact Verification

When verifying that work is complete, check artifacts at 4 increasing levels of rigor:

### Level 1: Exists
Does the file/function/component exist?
- `ls path/to/file` — it's on disk
- `grep "function myFunc"` — the function is defined

**This is the minimum. Most "verification" stops here. Don't.**

### Level 2: Substantive (Not a Stub)
Is it actually implemented, not just scaffolded?
- File has more than just boilerplate/imports
- Function has a real implementation, not just `// TODO` or `return null`
- Test file has actual assertions, not just `test('placeholder', () => {})`

**Check for these stub patterns:**
- `TODO`, `FIXME`, `PLACEHOLDER`, `NOT IMPLEMENTED`
- Empty function bodies
- Functions that only return null/undefined/empty
- Test files with no assertions

### Level 3: Wired (Connected)
Is it imported and used by the rest of the system?
- Component is imported somewhere, not just defined
- API endpoint is registered in the router
- Database migration is listed in the migration runner
- Config value is actually read by the code that needs it

**"Defined but never imported" = dead code, not a feature.**

### Level 4: Data Flowing
Does real data actually flow through it end-to-end?
- The API endpoint receives a request and returns a response with real data
- The component renders with actual props from the parent
- The database query returns rows that are displayed to the user
- The auth check actually blocks unauthorized access

**This is the only level that proves the feature works.**

### Verification Checklist Enhancement

When running validation, check each deliverable at all 4 levels:

| Deliverable | L1 Exists | L2 Substantive | L3 Wired | L4 Flowing |
|-------------|-----------|----------------|----------|------------|
| [item] | ✓/✗ | ✓/✗ | ✓/✗ | ✓/✗ |

A deliverable that passes L1 but fails L2-L4 is NOT complete.
