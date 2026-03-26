# Git Workflow -- Summary

Structured git workflow enforcing branch naming, atomic commits, and clean PR practices. Integrates with Melted Peak's change plans and regression checklists.

## When to Use
- Before creating branches, committing, or opening PRs
- During change plan execution
- When establishing project git conventions

## Key Conventions
- Branch naming: `[type]/[description]` (feat, fix, refactor, docs, test, chore)
- Commit messages: `[type]: [description]` -- atomic, one logical change per commit
- PR checklist: change plan verified, regression checklist checked, self-reviewed
- Merge: squash for features, merge commit for long-running, rebase for small fixes

## Context Cost
Small -- conventions guide, no reference material.
