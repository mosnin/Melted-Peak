# Data Modeling -- Summary

Comprehensive guide for designing data models from requirements through to production-ready schemas. Covers entity identification, relationship mapping, field design, normalization trade-offs, indexing strategy, soft deletes, audit trails, multi-tenancy patterns, and entity state machines.

## When to Use
- Translating a PRD or requirements document into database entities
- Designing relationships between entities (one-to-one, one-to-many, many-to-many, polymorphic)
- Deciding on field types, constraints, nullability, defaults, or enums vs lookup tables
- Evaluating normalization vs denormalization trade-offs
- Planning an indexing strategy for query performance
- Choosing between soft delete and hard delete
- Adding audit trails or timestamp conventions
- Designing multi-tenant data isolation
- Modeling entity state machines with status fields and transitions

## Key Topics
1. **Entity identification** -- extracting entities from requirements, naming conventions, singular table names vs plural
2. **Relationship mapping** -- join tables, foreign keys, polymorphic associations, self-referential relationships
3. **Field design** -- type selection, constraints, nullability rules, defaults, enums vs lookup tables
4. **Normalization guidance** -- normal forms, when to denormalize, materialized views, read replicas
5. **Index strategy** -- primary keys, unique indexes, composite indexes, partial indexes, covering indexes
6. **Soft delete vs hard delete** -- deleted_at patterns, query scoping, data retention, GDPR considerations
7. **Audit trails and timestamps** -- created_at, updated_at, deleted_at, created_by, updated_by, history tables
8. **Multi-tenancy patterns** -- shared schema with tenant_id, schema-per-tenant, database-per-tenant, row-level security
9. **State machines** -- status fields, transition tables, guard conditions, event sourcing considerations
10. **Schema documentation** -- ERD generation, field descriptions, data dictionaries
11. **Melted Peak integration** -- architecture decisions for model choices, change plans for schema changes

## Context Cost
Small -- reference guide only, no external dependencies.
