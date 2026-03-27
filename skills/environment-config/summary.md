# Environment Config -- Summary

Comprehensive guide for environment and configuration management across application lifecycles. Covers naming conventions, secret handling, configuration layering, type-safe validation, environment parity, .env file strategy, feature flags, and integration with Melted Peak workflows.

## When to Use
- Setting up environment configuration for a new project
- Refactoring scattered or inconsistent configuration patterns
- Reviewing secret management practices
- Adding feature flags or configuration layers
- Debugging environment-specific failures (works in dev, breaks in prod)
- Writing a change plan that touches configuration or environment variables

## Key Sections
1. **Environment Variable Strategy** -- Naming conventions, grouping by concern, documentation requirements
2. **Secret Management** -- What must never be in code, rotation practices, vault patterns, key separation
3. **Configuration Layers** -- Defaults, environment-specific overrides, runtime overrides, merge order
4. **Validation** -- T3 Env pattern, fail-fast on startup, type-safe env vars, schema definition
5. **Environment Parity** -- Dev/staging/production differences, minimizing drift, shared config structure
6. **.env File Management** -- .env.example as documented template, .env.local for local overrides, gitignore rules
7. **Feature Flags** -- When to use, simple implementation patterns, cleanup after rollout, flag lifecycle
8. **Configuration Anti-Patterns** -- Hardcoded values, magic strings, env-dependent logic scattered through code
9. **Melted Peak Integration** -- Change plans for config changes, regression checklist for env-sensitive areas

## Context Cost
Small -- single reference document, no external dependencies.
