# Skill: Database Migrations

## Purpose
Structured workflow for planning, authoring, testing, and executing database schema migrations safely. Covers reversibility assessment, impact analysis, safe patterns for large tables, rollback procedures, and data integrity validation.

## Trigger
- When a change plan involves database schema modifications
- When the user asks to create or review a migration
- When planning a feature that requires new tables, columns, indexes, or constraints
- When troubleshooting a failed or stuck migration

## Workflow

### Step 1: Schema Change Planning

Before writing any migration, analyze what is changing and what it affects.

#### Reversibility Assessment

Classify every change as reversible or irreversible:

| Change Type | Reversible? | Notes |
|------------|-------------|-------|
| Add column (nullable) | Yes | Drop column to reverse |
| Add column (non-null, no default) | Risky | Requires backfill; reverse may lose data |
| Drop column | No | Data is destroyed |
| Rename column | No | Unless using a two-phase rename |
| Add table | Yes | Drop table to reverse |
| Drop table | No | Data is destroyed |
| Add index | Yes | Drop index to reverse |
| Add constraint (check, FK) | Yes | Drop constraint to reverse |
| Change column type (widening) | Usually | e.g., int -> bigint |
| Change column type (narrowing) | No | Data may be truncated or lost |
| Modify enum values | Depends | Adding is safe; removing/renaming is not |

If any change is irreversible, flag it in `active/change_plan.md` with a bold warning and require explicit user confirmation before proceeding.

#### Impact Analysis

1. **Identify all consumers**: Which application code, views, stored procedures, ORMs, or external systems reference the affected tables/columns?
2. **Check query patterns**: Will the migration break or degrade existing queries? Will it invalidate query plans or cached statements?
3. **Estimate data volume**: How many rows are in the affected tables? Migrations on tables with millions of rows require special handling (see Large Table Migrations).
4. **Check for locks**: Will the migration acquire locks that block reads or writes? For how long?
5. **Downstream effects**: Are there replicas, materialized views, ETL pipelines, or CDC streams that depend on the schema?

Record findings in the `## Impact Analysis` section of `active/change_plan.md`.

### Step 2: Migration Authoring

#### Additive Changes (Safe by Default)

These changes can typically be applied without downtime:

- Adding a new table
- Adding a nullable column (no default required)
- Adding a nullable column with a non-volatile default
- Adding an index concurrently (Postgres: `CREATE INDEX CONCURRENTLY`)
- Adding a non-unique constraint that does not require a full table scan

Pattern for adding a nullable column:
```sql
ALTER TABLE orders ADD COLUMN tracking_number VARCHAR(100) NULL;
```

#### Destructive Changes (Require Extra Care)

These changes risk data loss or downtime:

- **Dropping a column**: First deploy code that no longer reads/writes the column. Wait for full rollout. Then drop.
- **Dropping a table**: Ensure no code references it. Consider renaming to `_deprecated_tablename` first, drop after a soak period.
- **Renaming a column**: Use a two-phase approach: (1) add new column, backfill, deploy code to use new column, (2) drop old column.
- **Changing a column type**: Add new column with target type, backfill, swap in application code, drop old column.
- **Removing enum values**: Only after verifying no rows use the value and no code sets it.

#### Safe Patterns

- **Expand-and-contract**: Add the new structure alongside the old one, migrate data, switch readers/writers, remove old structure. This is the fundamental pattern for zero-downtime migrations.
- **Feature flags**: Gate code that uses new schema behind a flag until migration is confirmed complete.
- **Backfill separately**: Do not backfill data inside the migration transaction. Use a separate script or background job.

### Step 3: Safety Checks

Run these checks before executing any migration:

#### Lock Timeout
Set a lock timeout to prevent migrations from blocking production traffic indefinitely:
```sql
SET lock_timeout = '5s';  -- Abort if lock not acquired in 5 seconds
```

If the lock times out, retry during a low-traffic window or investigate what is holding the lock.

#### Data Preservation
- Before dropping or altering a column: confirm a backup exists or the data is no longer needed.
- Before truncating or deleting: verify row counts and sample data.
- For irreversible changes: take a logical backup of affected tables.

#### Constraint Validation
- When adding a NOT NULL constraint: verify no null values exist first.
  ```sql
  SELECT COUNT(*) FROM orders WHERE tracking_number IS NULL;
  ```
- When adding a foreign key: verify referential integrity holds.
  ```sql
  SELECT COUNT(*) FROM order_items oi
  WHERE NOT EXISTS (SELECT 1 FROM orders o WHERE o.id = oi.order_id);
  ```
- When adding a CHECK constraint: verify all existing rows satisfy it.
- Add constraints as NOT VALID first, then VALIDATE separately (Postgres) to avoid long locks.

#### Pre-Flight Checklist

- [ ] Migration has been reviewed by a second person or by the code review skill
- [ ] Lock timeout is set
- [ ] Irreversible changes have been flagged and approved
- [ ] Backup of affected data exists (for destructive changes)
- [ ] Application code is compatible with both old and new schema
- [ ] Rollback script exists and has been tested

### Step 4: Rollback Procedures

#### Backwards-Compatible Migrations

The best rollback strategy is never needing one. Write migrations so that the application works with both the old and new schema simultaneously:

1. **Never remove something the current code depends on** in the same deploy.
2. **Deploy in phases**: schema change first (additive only), then code change, then cleanup migration.
3. **Test rollback**: Verify the application still works if the migration is reverted.

#### Rollback Scripts

Every migration should have a corresponding rollback script. Store them alongside the migration:

```
migrations/
  20260327_001_add_tracking_number.up.sql
  20260327_001_add_tracking_number.down.sql
```

Rules for rollback scripts:
- The rollback must be idempotent (safe to run multiple times).
- The rollback must not destroy data that was added after the migration ran (use `IF EXISTS` guards).
- Test the rollback in staging before deploying the migration to production.

#### When Rollback Is Impossible

For irreversible migrations (column drops, type narrowing, data transformations):
- Document that rollback requires restoring from backup.
- Ensure a point-in-time recovery target is recorded before executing.
- Consider a "soft delete" pattern: rename instead of drop, disable instead of remove.

### Step 5: Large Table Migrations

Tables with millions of rows require special techniques to avoid long locks and replication lag.

#### Batching

For data backfills or updates, process in batches:
```sql
-- Process 10,000 rows at a time
UPDATE orders
SET tracking_number = 'UNKNOWN'
WHERE tracking_number IS NULL
  AND id BETWEEN :start AND :start + 9999;
```

- Use a loop with a small sleep between batches to let replicas catch up.
- Monitor replication lag during execution.
- Log progress so the process can resume if interrupted.

#### Zero-Downtime Patterns

- **Online schema change tools**: Use `pt-online-schema-change` (MySQL) or `pg_repack` / `pgroll` (Postgres) for ALTER operations on large tables.
- **CREATE INDEX CONCURRENTLY** (Postgres): Does not lock the table for writes, but takes longer and cannot run inside a transaction.
- **Ghost tables**: Create a new table with the desired schema, copy data in batches, swap table names. Tools like `gh-ost` automate this for MySQL.
- **Shadow writes**: Write to both old and new tables during the migration period, then cut over.

#### Monitoring During Execution

- Watch for lock wait timeouts in the database error log.
- Monitor replication lag on replicas.
- Track migration progress (rows processed / total rows).
- Set alerts for query latency spikes during migration.

### Step 6: Data Integrity Validation

Run these checks after every migration:

#### Before/After Counts
```sql
-- Record before migration
SELECT COUNT(*) AS row_count FROM orders;  -- e.g., 1,523,847

-- After migration, verify
SELECT COUNT(*) AS row_count FROM orders;  -- Must match or differ only by expected amount
```

#### Constraint Verification
```sql
-- Verify all constraints are valid and enforced
SELECT conname, convalidated
FROM pg_constraint
WHERE conrelid = 'orders'::regclass;

-- Verify foreign keys hold
SELECT COUNT(*) FROM child_table c
WHERE NOT EXISTS (SELECT 1 FROM parent_table p WHERE p.id = c.parent_id);
-- Must return 0
```

#### Application Smoke Test
- Run the application's test suite against the migrated schema.
- Verify critical read and write paths manually or with integration tests.
- Check ORM model definitions match the new schema.

#### Checksum Validation (for data migrations)
When moving or transforming data, verify checksums:
```sql
-- Before: checksum of source
SELECT SUM(hashtext(CAST(ROW(id, amount, status) AS TEXT))) FROM orders_old;

-- After: checksum of target
SELECT SUM(hashtext(CAST(ROW(id, amount, status) AS TEXT))) FROM orders_new;
-- Must match
```

### Step 7: Testing Migrations

#### Staging Environment
- Always run migrations in a staging environment that mirrors production schema and approximate data volume before deploying to production.
- Use a production snapshot (anonymized) if possible.
- Run the full up-and-down cycle: apply, verify, rollback, verify, apply again.

#### Data Fixtures
- Maintain a set of representative test data that exercises edge cases: nulls, maximum-length strings, boundary numeric values, special characters.
- After migration, verify fixtures still load and behave correctly.
- Include fixtures that would violate new constraints (to verify constraints catch them).

#### Migration Test Checklist
- [ ] Migration applies cleanly to an empty database
- [ ] Migration applies cleanly to a database with production-like data
- [ ] Rollback script reverses the migration cleanly
- [ ] Application tests pass after migration
- [ ] Application tests pass after rollback
- [ ] Migration is idempotent or guarded against re-runs

### Step 8: Common Pitfalls

| Pitfall | Why It Fails | Safe Alternative |
|---------|-------------|------------------|
| Dropping a column that views or generated columns depend on | CASCADE drops dependents silently | Check `pg_depend` / `information_schema` first |
| Adding a NOT NULL column without a default | Fails on tables with existing rows | Add as NULL, backfill, then set NOT NULL |
| Adding/removing enum values in a transaction (Postgres) | Cannot alter enums inside a transaction | Run outside a transaction block |
| Creating an index on a large table without CONCURRENTLY | Locks the table for writes for the duration | Use `CREATE INDEX CONCURRENTLY` |
| Running a long backfill inside the migration transaction | Holds locks, blocks other operations, risks timeout | Backfill in a separate script with batching |
| Changing a primary key type | Cascades to all foreign keys, very expensive | Expand-and-contract with a new column |
| Assuming column order matters | Queries using `SELECT *` may break | Always use explicit column lists |
| Not testing rollback | Discover rollback is broken during an incident | Test rollback in staging before every deploy |

## Integration with Melted Peak

### Change Plan
When a task involves database migrations, `active/change_plan.md` must include:
- A `## Database Migration` section listing each migration with its classification (additive/destructive/reversible/irreversible)
- Lock timeout settings to use
- Rollback approach for each migration step
- Order of operations: migration first vs. code first

### Regression Checklist
After any migration, add entries to `active/regression_checklist.md` for:
- Tables that were altered (verify queries still work)
- Indexes that were added or removed (verify query performance)
- Constraints that were added (verify writes still succeed)
- Any data transformations (verify data integrity)

### Active Issue
If a migration fails or causes issues, log it in `active/active_issue.md` with:
- The exact error message
- The migration state (partially applied? rolled back?)
- Which step of this skill workflow was being executed

### Progress Log
Record in `memory/progress_log.md`:
- Migration planned (with classification summary)
- Migration tested in staging
- Migration applied to production
- Post-migration validation passed

## Anti-Patterns

- Writing migrations without checking existing data volume -- large tables need special handling
- Deploying code changes and schema changes in the same release -- decouple them
- Skipping rollback scripts for "simple" migrations -- every migration needs a rollback path
- Running migrations without a lock timeout -- a single stuck lock can take down production
- Backfilling inside the migration transaction -- use a separate batched process
- Testing only the "up" migration -- always test the full up/down/up cycle
- Assuming staging matches production -- verify table sizes and data distribution
- Dropping columns before removing all code references -- deploy code removal first, drop column later
