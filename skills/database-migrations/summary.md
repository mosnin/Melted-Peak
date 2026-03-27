# Database Migrations -- Summary

Structured workflow for safely planning, writing, testing, and executing database schema migrations. Covers reversibility assessment, impact analysis, rollback procedures, large table strategies, and data integrity validation.

## When to Use
- When a change plan involves database schema modifications
- When creating or reviewing a migration script
- When planning features that require new tables, columns, indexes, or constraints
- When troubleshooting a failed or stuck migration

## Key Steps
1. **Plan**: Classify changes as reversible/irreversible, identify all consumers, estimate data volume, assess lock impact
2. **Author**: Use additive patterns by default; use expand-and-contract for destructive changes; never combine schema and code deploys
3. **Safety checks**: Set lock timeouts, verify data preservation, validate constraints before enforcing them
4. **Rollback**: Write a rollback script for every migration; test the full up/down/up cycle in staging
5. **Large tables**: Batch data operations, use online schema change tools, create indexes concurrently, monitor replication lag
6. **Validate**: Compare before/after row counts, verify constraints hold, run application smoke tests
7. **Test**: Run in staging with production-like data, test with edge-case fixtures, verify rollback works
8. **Integrate**: Add migration details to change plan, update regression checklist with affected tables and constraints

## Common Pitfalls
- Dropping columns before removing code references
- Adding NOT NULL columns without defaults on populated tables
- Creating indexes without CONCURRENTLY on large tables
- Running long backfills inside migration transactions
- Skipping rollback testing

## Context Cost
Small -- workflow guide only.
