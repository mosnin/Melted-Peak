# Dependency Update -- Summary

Four-phase workflow for safely updating project dependencies: Assess, Plan, Execute, Document. Prevents blind updates that cause surprise breakage.

## When to Use
- User requests a dependency update
- Security vulnerability found
- New version needed for a feature
- Routine maintenance

## Key Steps
1. **Assess**: Read changelog, check dependency tree, rate risk level
2. **Plan**: Write change plan listing all files that use the dependency, rollback strategy
3. **Execute**: Snapshot current state, update package, apply code changes, run validation
4. **Document**: Update dependency map, change log, regression checklist

## Critical Rules
- Always read the changelog before updating
- One dependency at a time
- Always have a rollback path (known-good commit/lock file)
- Check transitive dependencies for conflicts

## Context Cost
Small -- workflow guide only.
