# Code Review -- Summary

Structured review workflow that checks correctness, safety, consistency, dependencies, and tests before code is committed. Integrates with the regression checklist.

## When to Use
- Before committing changes
- After completing a change plan
- When user requests a review
- When validating external contributions

## Key Steps
1. Understand the intent (read change plan/issue)
2. Enumerate all changed files
3. Review each file for correctness, safety, consistency, dependencies, tests
4. Check regression checklist for affected sensitive areas
5. Categorize findings: blocker, issue, suggestion, question, positive
6. Report findings with file references and suggested fixes

## Depth Levels
- **Quick**: Small changes, scan for obvious issues
- **Standard**: Feature/bug work, full workflow
- **Deep**: Security/shared code, trace all callers

## Context Cost
Small -- workflow guide only.
