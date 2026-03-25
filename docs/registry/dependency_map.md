# Component Dependency Map

Maps relationships between Melted Peak components. Used by the context compiler to ensure co-dependencies are loaded together.

## How to Read

- `A → B` means A depends on B (loading A requires also loading B)
- `A ↔ B` means A and B are mutually dependent

## Current Dependencies

No cross-component dependencies registered yet.

<!-- Example format:
## frameworks/example-framework
- Depends on: knowledge/example-knowledge
- Reason: Uses domain patterns defined in the knowledge pack

## skills/example-skill
- Depends on: frameworks/example-framework
- Reason: Implements a workflow defined by the framework
-->
