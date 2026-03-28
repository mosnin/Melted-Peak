---
name: deployment-workflow
description: Use when deploying to staging or production — pre-deploy validation, execution, post-deploy verification, and rollback procedures
user-invocable: false
---

# Deployment Workflow

**Pre-deploy:** all tests pass, changelog updated, version bumped, change plan approved.
**Deploy:** follow project-specific deployment steps. **Post-deploy:** smoke tests, monitoring, verify key user flows.
**Rollback:** if anything fails post-deploy, revert immediately, investigate after.

See `skills/deployment-workflow/source/SKILL.md` for full workflow.
