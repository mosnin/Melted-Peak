# Skill: Refactoring

## Purpose
Safe, incremental refactoring workflow that restructures code without changing behavior. Ensures each step is verified before moving to the next, with rollback checkpoints throughout.

## Trigger
- User requests a refactor
- Code review identifies structural issues
- Context compiler selects work type `refactor`
- Technical debt cleanup

## Philosophy

> "Make the change easy, then make the easy change." -- Kent Beck

Refactoring is not rewriting. It is a series of small, behavior-preserving transformations. Each transformation is verified before the next begins.

## Workflow

### Phase 1: Understand What Exists

1. **Map the territory** -- before changing anything:
   - What does this code do? (trace the execution path)
   - What depends on this code? (imports, consumers, callers)
   - What does this code depend on? (dependencies, APIs, shared state)
   - Are there tests? What do they cover?

2. **Define the goal** -- write to `active/change_plan.md`:
   - What structural problem are we solving?
   - What should the code look like after refactoring?
   - What must NOT change? (behavior, API contracts, external interfaces)

3. **Verify baseline**:
   - Run existing tests -- do they pass? (this is your safety net)
   - If no tests exist, consider writing characterization tests first
   - Note the current behavior explicitly

### Phase 2: Plan the Steps

4. **Decompose into atomic transformations**:
   Each step should be:
   - Small enough to verify independently
   - Behavior-preserving (tests still pass after each step)
   - Committable (clean state between steps)

   Common atomic transformations:
   | Transformation | Example |
   |---------------|---------|
   | Extract function | Pull logic into a named function |
   | Inline function | Replace a trivial wrapper with its body |
   | Rename | Change a name for clarity |
   | Move | Relocate code to a better home |
   | Extract interface | Define a contract between components |
   | Replace conditional with polymorphism | Strategy pattern |
   | Consolidate duplicates | DRY repeated logic into shared function |

5. **Order the steps** -- dependencies first:
   - Renames before moves (so references are clear)
   - Extractions before consolidations (so pieces exist to consolidate)
   - Interface changes before implementation changes

### Phase 3: Execute Incrementally

6. **For each transformation step**:
   ```
   a. Describe the step (what and why)
   b. Execute the transformation
   c. Run tests -- MUST pass
   d. Commit with message: "refactor: [what was done]"
   e. If tests fail: REVERT immediately, investigate, adjust approach
   ```

7. **Checkpoint rules**:
   - Never have more than one uncommitted transformation
   - If you realize the approach is wrong, revert to the last commit
   - If the refactoring reveals a bug, STOP -- log it in `memory/known_issues.md`, don't fix it inline

### Phase 4: Verify

8. **Post-refactoring checks**:
   - All original tests pass
   - Behavior is unchanged (same inputs → same outputs)
   - No new warnings or errors
   - Code is actually clearer (not just different)
   - Check `active/regression_checklist.md` for affected areas

9. **Update the system**:
   - Close the change plan with outcomes
   - Update `memory/recent_deltas.md` with all files changed
   - If this created a pattern worth reusing, log in `memory/metrics/pattern_journal.md`

## When NOT to Refactor

- During a bug fix (fix the bug first, refactor separately)
- When you don't understand the code yet (understand first)
- When there are no tests and you can't write them
- When the code is being replaced soon anyway
- Under time pressure (refactoring needs patience)

## Common Mistakes

- **Big bang refactoring**: Trying to change everything at once. Always decompose.
- **Refactoring and adding features simultaneously**: These are separate activities. Do one at a time.
- **No verification between steps**: Each step must be verified. Skipping this compounds errors.
- **Refactoring code you don't understand**: You'll break things you don't know about.
- **Renaming without updating all references**: Search the entire codebase, not just the current file.
