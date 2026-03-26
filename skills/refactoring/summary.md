# Refactoring -- Summary

Safe, incremental refactoring workflow. Each transformation is atomic, behavior-preserving, and verified before the next step. Philosophy: "Make the change easy, then make the easy change."

## When to Use
- User requests a refactor
- Code review finds structural issues
- Technical debt cleanup

## Key Steps
1. **Understand**: Map dependencies, trace execution, verify baseline tests pass
2. **Plan**: Decompose into atomic transformations, order by dependency
3. **Execute**: One step at a time -- transform, test, commit. Revert if tests fail.
4. **Verify**: All tests pass, behavior unchanged, regression checklist checked

## Critical Rules
- Never combine refactoring with feature work
- Never skip verification between steps
- Revert immediately if tests fail
- If you find a bug during refactoring, log it -- don't fix inline

## Context Cost
Small -- workflow guide.
