# Skill: Git Workflow

## Purpose
Structured git workflow that enforces branch discipline, meaningful commits, and clean PR practices. Integrates with Melted Peak's change plan and regression checklist.

## Trigger
- Before creating a branch or committing code
- When user asks about git workflow
- During change plan execution (commit phase)
- Before creating a PR

## Workflow

### Branch Strategy

#### Naming Convention
```
[type]/[short-description]

Types:
  feat/     - New feature
  fix/      - Bug fix
  refactor/ - Code restructuring
  docs/     - Documentation
  test/     - Test additions
  chore/    - Maintenance, deps, config
```

Examples: `feat/user-auth`, `fix/login-redirect`, `refactor/api-layer`

#### Branch Rules
- Always branch from the latest main/develop
- One branch per issue (matches issue isolation protocol)
- Delete branches after merge
- Never commit directly to main

### Commit Discipline

#### Before Every Commit
1. Read `active/change_plan.md` -- does this commit match the plan?
2. Run `git diff --staged` mentally -- review what's being committed
3. Ensure no secrets, env files, or build artifacts are staged
4. Ensure the commit is atomic (one logical change)

#### Commit Message Format
```
[type]: [concise description]

[optional body: why this change was made]

[optional footer: references to issues, breaking changes]
```

Types match branch types: feat, fix, refactor, docs, test, chore

**Good**: `feat: add token refresh to auth middleware`
**Bad**: `update stuff` / `fix` / `WIP` / `changes`

#### Commit Frequency
- Commit after each logical step in the change plan
- Never commit half-finished work without WIP prefix
- Prefer many small commits over one large commit
- Each commit should leave the codebase in a working state

### PR Practices

#### Before Creating a PR
1. Rebase on latest main (resolve conflicts locally)
2. Run the code-review skill on your own changes
3. Verify `active/validation_plan.md` passes
4. Check `active/regression_checklist.md` -- all affected areas verified?

#### PR Description Template
```markdown
## What
[One sentence: what this PR does]

## Why
[Context: what problem it solves, reference to active_issue]

## How
[Brief technical approach]

## Testing
[What was verified, which tests pass]

## Checklist
- [ ] Change plan executed as written (or deviations documented)
- [ ] Regression checklist reviewed
- [ ] No secrets or env files committed
- [ ] Code review skill run (self-review)
```

#### Merge Strategy
- Squash merge for feature branches (clean history)
- Merge commit for long-running branches (preserve context)
- Rebase for small fixes (linear history)
- Always delete branch after merge

### Integration with Melted Peak

- **Change plan → commits**: Each step in the change plan maps to one or more commits
- **Issue resolution → PR**: Closing an active issue should have a corresponding PR
- **Regression checklist → PR checklist**: Include checklist verification in PR
- **Progress log**: After merge, update `memory/progress_log.md`
- **Change log**: After merge, update `memory/change_log.md`

## Anti-Patterns
- Committing generated files or node_modules
- Giant commits with unrelated changes
- Force-pushing to shared branches
- Merging without reviewing your own code first
- Leaving stale branches around
