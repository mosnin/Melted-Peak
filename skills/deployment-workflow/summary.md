# Deployment Workflow -- Summary

Structured deployment workflow covering pre-deployment validation, execution strategies (blue-green, canary, rolling), post-deployment verification, and rollback procedures. Integrates with Melted Peak's change plans and regression checklists.

## When to Use
- Before deploying changes to staging or production
- When choosing a deployment strategy for a project
- When a rollback is needed after a failed deploy
- When verifying environment parity between staging and production

## Key Phases
1. **Pre-deploy**: Config checks, migration safety, environment verification, change plan alignment
2. **Execute**: CI/CD pipeline with approval gates; blue-green, canary, or rolling strategy
3. **Post-deploy**: Smoke tests, health checks (15-30 min), business metric monitoring (1-4 hr)
4. **Rollback**: Immediate on critical failures; redeploy previous artifact, verify recovery
5. **Parity**: Staging mirrors production in infrastructure, data, config, and dependencies

## Melted Peak Integration
- Change plan steps map to deployment verification assertions
- Regression checklist reviewed before every deploy
- Deployment outcomes logged to progress log; failures become active issues

## Context Cost
Small -- procedural guide, no reference material.
