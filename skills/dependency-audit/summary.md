# Dependency Audit -- Summary

Comprehensive dependency audit workflow that evaluates a project's dependency health across eight dimensions: inventory, vulnerability scanning, freshness, license compliance, bundle impact, unused detection, upgrade path planning, and automation strategy. Produces a prioritized action plan for dependency maintenance.

## When to Use
- Before a major release to verify dependency health
- When onboarding to a new or inherited codebase
- During quarterly or periodic maintenance cycles
- When a vulnerability is reported in a dependency
- When bundle size has grown unexpectedly
- When the user requests a dependency review or audit

## Key Steps
1. Build a dependency inventory (all deps, versions, purpose, last updated)
2. Scan for vulnerabilities (npm audit, known CVEs, severity classification)
3. Assess freshness (how far behind latest, breaking changes between versions)
4. Check license compliance (copyleft, restrictive, or incompatible licenses)
5. Analyze bundle impact (largest deps, lighter alternatives)
6. Detect unused dependencies (installed but never imported)
7. Plan upgrade paths (priority order, dependency chains, breaking changes)
8. Evaluate automation (dependabot, renovate, what needs manual review)
9. Integrate findings with Melted Peak (dependency_map, known_issues, change_plan)

## Depth Levels
- **Quick scan**: Inventory + vulnerabilities + unused detection only
- **Standard**: All eight dimensions, surface-level analysis
- **Deep**: All dimensions with full tracing, alternative research, and upgrade plan

## Context Cost
Small -- workflow guide only.
