# Estimation -- Summary

Systematic task estimation that classifies complexity, decomposes into subtasks, identifies unknowns, and produces calibrated scope estimates with confidence levels. Integrates with change plans and retrospectives for continuous accuracy improvement.

## When to Use
- Before writing a change plan for non-trivial work
- When the user asks how big or how long a task will take
- Before starting work that touches 3+ files
- When scope or risk feels uncertain

## Key Steps
1. **Classify complexity**: trivial, simple, moderate, complex, or unknown
2. **Decompose**: Break into independently verifiable subtasks with effort ratings
3. **Identify risks**: Unfamiliar code, external dependencies, unclear requirements, missing tests
4. **Estimate scope**: Files, logical changes, tests, lines changed
5. **Assign confidence**: High (+/-20%), Medium (+/-50%), Low (+/-100%)
6. **Check signals**: Compare against similar past tasks from progress_log
7. **Check size**: Push back if too big for one change plan -- recommend splitting

## Critical Rules
- Unknown complexity means stop and investigate first
- Low confidence must be explicitly flagged to the user
- Push back on oversized tasks (5+ files, 200+ lines, 3+ medium/high unknowns)
- Calibrate by comparing actual vs. estimated in retrospectives
- Never estimate without reading the relevant code

## Context Cost
Small -- workflow guide with classification tables and output templates.
