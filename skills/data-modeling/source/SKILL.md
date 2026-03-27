# Skill: Data Modeling

## Purpose
Design data models that accurately represent business domains, support required queries efficiently, and evolve safely over time.

## Trigger
- Designing a new feature that needs persistent data
- Architecture phase of a project (Phase 3 in Modaf)
- Schema change or new entity creation
- Reviewing existing data model for improvements

## Workflow

### Step 1: Identify Entities

From the requirements, PRD, or user stories, extract:

1. **Nouns are entities**: User, Project, Invoice, Comment, Team
2. **Verbs are relationships**: User *creates* Project, Team *has* Members
3. **Adjectives are fields**: active User, overdue Invoice, public Project

Write the entity list with a one-line description of each.

### Step 2: Map Relationships

| Relationship | Pattern | Implementation |
|-------------|---------|----------------|
| One-to-one | User has one Profile | Foreign key on either table, unique constraint |
| One-to-many | User has many Projects | Foreign key on the "many" side (projects.user_id) |
| Many-to-many | Users belong to many Teams | Join table (team_members: user_id + team_id) |
| Polymorphic | Comment on Post OR Comment on Task | Separate foreign keys, or discriminator pattern |
| Self-referential | Category has subcategories | parent_id on same table |

Rules:
- Always define the relationship from both sides
- Foreign keys need indexes
- Many-to-many join tables often need their own fields (role, joined_at)

### Step 3: Design Fields

For each entity, define fields:

```
field_name:
  type: string | integer | boolean | datetime | enum | json | decimal
  nullable: true | false
  default: [value] | null | auto
  constraints: [unique, min, max, format]
  index: true | false
  notes: [why this field exists]
```

#### Type Selection Guide

| Data | Type | Notes |
|------|------|-------|
| Names, titles, descriptions | string (varchar) | Set max length |
| Counts, quantities | integer | Use bigint for IDs |
| Prices, currency | decimal(10,2) | Never use float for money |
| Yes/no flags | boolean | Default to false |
| Timestamps | datetime (UTC) | Always store in UTC |
| Status/category | enum | Use enum for fixed sets, lookup table for dynamic |
| Flexible structure | json/jsonb | Use sparingly -- can't index effectively |
| Unique identifiers | uuid or cuid | Prefer cuid2 for sortability |

### Step 4: Add Standard Fields

Every entity should have:

```
id          - Primary key (cuid2 or uuid)
created_at  - When the record was created (auto, UTC)
updated_at  - When last modified (auto, UTC)
```

Optional standard fields:
```
deleted_at  - Soft delete timestamp (null = active)
created_by  - Who created it (user ID foreign key)
updated_by  - Who last modified it
version     - Optimistic locking counter
```

### Step 5: Design Indexes

| Index When | Type |
|-----------|------|
| Foreign keys | Single column (always) |
| Frequent WHERE clauses | Single or composite |
| Unique constraints (email, slug) | Unique index |
| Sorting columns (created_at) | Single column |
| Full-text search | GIN/GiST (Postgres) |
| Soft delete filtering | Partial index: WHERE deleted_at IS NULL |

Composite index order: most selective column first.
Don't over-index -- each index slows writes.

### Step 6: Handle State Machines

For entities with status/lifecycle:

1. Define all possible states: `draft → active → paused → completed → archived`
2. Define valid transitions: `draft → active` (yes), `completed → draft` (no)
3. Implement as enum field + transition validation
4. Log state changes with timestamp and actor

### Step 7: Plan for Multi-Tenancy

If the app serves multiple organizations:

| Pattern | When to Use |
|---------|------------|
| **Shared schema + tenant_id** | Most SaaS apps. Add org_id to every table, enforce in queries |
| **Row-level security** | PostgreSQL RLS policies. Enforced at DB level |
| **Schema per tenant** | High isolation requirements. Complex migrations |

For shared schema: every query MUST filter by tenant_id. Use middleware or ORM scoping to enforce.

### Step 8: Document the Model

Create a summary with:
- Entity list with descriptions
- Relationship diagram (ASCII or mermaid)
- Key constraints and business rules
- Index strategy rationale

Record design decisions in `memory/architecture_decisions.md`.

## Soft Delete vs Hard Delete

| Approach | Use When |
|----------|---------|
| **Soft delete** (deleted_at) | Need audit trail, undo capability, or referential integrity |
| **Hard delete** (DELETE) | Truly ephemeral data, GDPR right-to-erasure, no references |
| **Archive table** | Need to keep data but reduce active table size |

## Anti-Patterns

- **God table**: One table with 50+ columns. Split into logical entities.
- **Generic key-value**: Using a generic `settings(key, value)` table for everything. Model real entities.
- **No indexes on foreign keys**: Joins become full table scans.
- **Float for currency**: Rounding errors. Use decimal.
- **Nullable everything**: If a field is always required, make it NOT NULL.
- **No timestamps**: Always track created_at and updated_at.
