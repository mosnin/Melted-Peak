# Modaf SaaS Internal Knowledge -- Summary

Comprehensive reference documentation for building SaaS applications. Covers the full internal app layer: authentication, onboarding, dashboard, feature modules, settings, billing, admin, email, UI system, data models, build rules, and quality gates.

## When to Load

- During any SaaS build phase (4-14)
- When working on auth, dashboard, features, settings, billing, admin, or email
- When making architecture decisions about SaaS apps
- Load specific docs by phase, not all at once

## Quick File Reference

| # | File | When Needed |
|---|------|------------|
| 01 | app_shell.md | Phase 7 -- layout, nav, sidebar |
| 02 | auth_and_onboarding.md | Phase 5-6 -- auth + onboarding flows |
| 03 | dashboard_system.md | Phase 8 -- dashboard anatomy |
| 04 | feature_modules.md | Phase 3, 9 -- optional modules |
| 05 | settings_billing_admin.md | Phase 10-11 -- settings + admin |
| 06 | routes_and_permissions.md | Phase 3, 5 -- routing + roles |
| 07 | data_models.md | Phase 3-4 -- entities + Prisma schema |
| 08 | ui_system_internal.md | Phase 7, 9 -- component behaviors |
| 09 | build_rules_internal.md | Phase 3-14 -- coding standards, API patterns |
| 10 | design_tokens_internal.md | Phase 7 -- visual system |
| 11-13 | screen/component/data specs | Phase 8-9 -- layouts + visuals |
| 14 | email_system.md | Phase 12 -- email templates |
| 15-16 | breakpoints + dashboard archetypes | Phase 7-8 |
| 17 | error_state_taxonomy.md | Phase 9, 14 -- error handling |
| 18-19 | testing + i18n | Phase 14 |
| 20 | subagent_dispatch.md | Parallelizing phases |
| 21 | validation_gates.md | Phase 4-14 -- quality checks |
| 22 | pattern_snapshot.md | Phase 7+ -- drift prevention |
| 23 | escape_hatches.md | Phase 2-3 -- tech swap guide |
| 24-25 | error recovery + doctor mode | Any phase |
| 26-28 | observability + performance + a11y | Phase 4, 14 |

## Context Cost
Large -- 28 internal docs + phase indexes. Load individual files by phase number, never all at once.
