# Example: The Context-Boot Skill

This walkthrough demonstrates the correct structure for a Melted Peak skill by examining the built-in `context-boot` skill.

## Directory Structure

```
skills/context-boot/
├── source/
│   └── SKILL.md          # The workflow logic
├── manifest.yaml          # Machine-readable metadata
└── summary.md             # Short operational overview
```

## The Three Required Files

### 1. source/SKILL.md

This is the core of the skill. It defines:
- **Purpose**: What the skill does (one sentence)
- **Trigger**: When to execute the skill
- **Workflow**: Step-by-step procedure
- **Output**: What the result looks like
- **Error Handling**: What to do when things go wrong

The workflow should be specific enough that the AI agent can follow it without ambiguity.

### 2. manifest.yaml

Machine-readable metadata. Key fields:
- `name`: Unique identifier used in registry lookups
- `status`: Must be `ready` to be used (enforced by readiness gate)
- `context_cost`: Tells the context compiler how much window this uses
- `triggers`: Conditions that activate the skill (used by context compiler for auto-selection)
- `dependencies`: Other components that must also be loaded

### 3. summary.md

A quick-scan overview readable in under 60 seconds. Contains:
- What it does (2-3 sentences)
- When to use it (conditions)
- Key steps (bullet points)
- Dependencies and context cost

The context compiler reads summaries first and only loads full source when needed.

## Registry Entry

The skill must be registered in `docs/registry/skill_index.yaml`:

```yaml
skills:
  - name: context-boot
    path: skills/context-boot/
    status: ready
    context_cost: small
    tags: [system, boot, context]
    triggers: [session-start]
    description: Boot the Melted Peak context system at session start
```

## Creating a New Skill

1. Create the directory: `skills/[name]/source/`
2. Write `source/SKILL.md` with the workflow
3. Copy `docs/templates/skill_manifest_template.yaml` to `manifest.yaml` and fill it in
4. Write `summary.md`
5. Add entry to `docs/registry/skill_index.yaml`
6. Update `docs/registry/dependency_map.md` if dependencies exist
7. Set status to `ready` after verifying all files
