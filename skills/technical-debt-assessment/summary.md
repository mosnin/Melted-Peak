# Technical Debt Assessment -- Summary

Systematic workflow for identifying, classifying, prioritizing, and managing technical debt. Provides frameworks for deciding when to accept debt, when to pay it down, and how to prevent accumulation.

## When to Use
- Auditing a codebase for existing debt
- Before planning a major feature (to understand constraints)
- When velocity has visibly degraded
- During retrospectives that surface recurring friction
- When onboarding to a new or unfamiliar codebase

## Key Phases
1. **Identify** -- scan for code smells, architecture violations, outdated dependencies, missing tests, documentation gaps
2. **Classify** -- tag each item by intent (intentional/accidental/bit rot), impact (high/medium/low), and fix cost (trivial to large)
3. **Analyze** -- cost-benefit evaluation: ongoing friction, risk exposure, compound interest vs. fix effort and disruption
4. **Inventory** -- structured log (DEBT-NNN entries) with category, location, impact, fix approach, and status
5. **Prioritize** -- score using Risk x Frequency x Fix Cost matrix; sort into critical/high/medium/low tiers
6. **Pay Down** -- select strategy: boy scout rule, dedicated sprints, alongside features, strangler pattern, or debt firebreak
7. **Prevent** -- code review gates, complexity budgets, dependency freshness checks, test coverage floors, ADRs

## Metrics Tracked
- Debt ratio, age distribution, paydown rate, category breakdown, velocity impact

## Melted Peak Integration
- High-impact items logged to `memory/known_issues.md` with `[tech-debt]` tag
- Recurring patterns logged to `memory/metrics/pattern_journal.md`
- Debt incidents feed into the retrospective skill
- Refactored areas added to `active/regression_checklist.md`

## Context Cost
Small -- workflow and framework guide only.
