# Naming Conventions

Defines naming standards for Melted Peak system files and components. Consistent naming enables the context compiler to find things and prevents confusion.

---

## Component Names

| Component Type | Convention | Example |
|---------------|-----------|---------|
| Skill | lowercase-with-hyphens | `code-review`, `git-workflow` |
| Knowledge | lowercase-with-hyphens | `debugging-patterns`, `performance-patterns` |
| Framework | lowercase-with-hyphens | `testing-strategy-framework` |
| Peak | lowercase-with-hyphens | `modaf-saas`, `nextjs-frontend` |
| Protocol (docs/core) | `NN_snake_case.md` | `07_issue_isolation_protocol.md` |
| Template | `snake_case_template.yaml|md` | `skill_manifest_template.yaml` |
| Prompt | `snake_case.md` | `session_start.md` |

## File Numbering (docs/core/)

Numbers indicate reading priority, not strict order:

| Range | Category |
|-------|---------|
| 00-03 | Foundation (system overview, principles, compiler, maintenance) |
| 04-09 | Operations (rotation, integration, handoff, isolation, scope, parallel) |
| 10-16 | Engineering (ingestion, readiness, knowledge, decisions, naming, error recovery, confidence) |
| 20-25 | Quality (self-audit, change control, regression) |
| 99 | Cheatsheet (always last) |

Gaps are intentional -- they leave room for future protocols without renumbering.

## Registry Tags

Use existing tags where possible. Common tag vocabulary:

| Category | Tags |
|----------|------|
| Work type | bug-fix, new-feature, refactor, investigation, deployment, security |
| Domain | frontend, backend, fullstack, devops, database, auth |
| Quality | testing, review, audit, accessibility, performance |
| System | meta, system, boot, self-improvement, peaks |
| Process | workflow, planning, estimation, documentation |

## Peak Namespacing

Peak-provided components use the prefix `[peak-name]/`:
- `modaf-saas/saas-phase-workflow`
- `modaf-saas/saas-internal`

This prevents naming collisions between peaks and core components.
