# Environment Config -- Summary

Comprehensive guide for environment and configuration management. Covers naming conventions, secret handling, configuration layering, type-safe validation, environment parity, .env file workflows, feature flags, and common anti-patterns.

## When to Use
- Setting up configuration for a new project or service
- Refactoring scattered configuration into a structured approach
- Adding or rotating secrets and credentials
- Designing feature flag strategy for a rollout
- Reviewing configuration for security or reliability issues
- Minimizing environment drift between dev, staging, and production

## Key Sections
1. **Environment Variable Strategy** -- Naming conventions, grouping by service, documentation requirements
2. **Secret Management** -- What never belongs in code, rotation practices, vault patterns, access scoping
3. **Configuration Layers** -- Defaults, environment-specific overrides, runtime overrides, precedence rules
4. **Validation** -- T3 Env pattern, fail-fast on startup, type-safe env vars, schema definitions
5. **Environment Parity** -- Minimizing dev/staging/production drift, shared config shapes, parity checklist
6. **.env File Management** -- .env.example as documented template, .env.local for local overrides, gitignore rules
7. **Feature Flags** -- When to use, simple implementation patterns, cleanup after rollout, flag lifecycle
8. **Anti-Patterns** -- Hardcoded values, magic strings, environment-dependent logic scattered through code
9. **Melted Peak Integration** -- Change plans for config changes, regression checklist for env-sensitive areas

## Context Cost
Small -- single reference document, no external dependencies.
