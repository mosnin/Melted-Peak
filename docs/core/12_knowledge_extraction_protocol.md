# Knowledge Extraction Protocol

Defines how to systematically learn a new codebase and extract reusable knowledge. When you enter an unfamiliar codebase, chaos is the default. This protocol creates order.

---

## When to Use

- Starting work in a new or unfamiliar codebase
- Onboarding to a project for the first time
- After a major architectural change that invalidates previous understanding
- When context about the codebase feels thin

## The Extraction Process

### Layer 1: Structure (5 minutes)

Map the high-level shape:
1. Read the project's README / docs
2. Read the directory structure (top 2 levels)
3. Identify: entry points, config files, package manifest
4. Note: language, framework, build system, test framework

Write a quick orientation to `active/active_context.md`:
```
Project: [name]
Stack: [language + framework + database]
Entry: [main entry points]
Tests: [test framework, location]
Config: [key config files]
```

### Layer 2: Architecture (10 minutes)

Understand how the pieces connect:
1. Trace the main data flow (request → processing → response)
2. Identify the key abstractions (models, services, controllers, etc.)
3. Map the dependency direction (who depends on whom)
4. Find the shared utilities / common code

Record findings in `memory/architecture_decisions.md` as observations:
```
### Observation: [codebase] Architecture
- **Pattern**: [MVC, Clean Architecture, etc.]
- **Data flow**: [request path]
- **Key abstractions**: [list]
- **Dependency direction**: [description]
```

### Layer 3: Conventions (10 minutes)

Understand the implicit rules:
1. How are files named? (PascalCase, kebab-case, by feature, by type)
2. How are errors handled? (try/catch, Result type, error middleware)
3. How is state managed? (global store, context, server state)
4. How are tests structured? (colocated, separate directory, naming convention)
5. How are imports organized? (absolute, relative, aliases)

Record conventions that the context compiler should load for future work.

### Layer 4: Sensitive Areas (ongoing)

As you work, identify fragile code:
1. Code with many dependents (changing it breaks many things)
2. Code with complex logic (hard to understand, easy to break)
3. Code with no tests (changes can't be verified)
4. Code with magic numbers or implicit behavior

Add these to `active/regression_checklist.md` immediately.

## What to Capture as Knowledge

If the codebase has patterns worth reusing, create a knowledge pack:

| Signal | Knowledge Pack Type |
|--------|-------------------|
| Custom authentication flow | Auth patterns knowledge |
| Complex data model with business rules | Domain model reference |
| Non-obvious deployment process | DevOps knowledge |
| Project-specific conventions that differ from defaults | Conventions reference |

Use the ingestion protocol to formalize into `knowledge/[name]/`.

## Integration with Context Compiler

After extraction, update the context compiler's mental model:
- Which files to read for different work types in THIS project
- Which areas are high-risk and need regression checking
- Which patterns are unique to this project vs. standard

## Anti-Patterns

- Reading every file before starting work (too slow, most isn't relevant)
- Assuming the architecture matches the documentation (verify)
- Ignoring tests as a source of truth (tests show actual behavior)
- Not recording what you learn (the next session loses it all)
