# Testing Strategy -- Summary

Guide for test planning: risk-based prioritization, test type selection, structuring tests, and meaningful coverage evaluation.

## When to Use
- Writing tests for new or changed code
- Planning test strategy for a feature
- Evaluating test coverage
- Validation plan execution

## Key Decisions
- **What to test**: Prioritize by risk (critical > high > medium > low)
- **Test type**: Unit (logic) → Integration (boundaries) → E2E (user journeys) → Component (UI behavior)
- **Coverage**: > 80% line coverage for critical paths, but focus on risk, not numbers

## Test Structure
Arrange-Act-Assert. Name tests: "should [behavior] when [condition]". Cover: happy path, edge cases, error cases, state transitions.

## Context Cost
Small -- decision guide with tables.
