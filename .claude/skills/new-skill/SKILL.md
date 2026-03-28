---
name: new-skill
description: Create a new project-specific skill via the skill router interview — scaffolds 3-file structure, validates, and registers
user-invocable: true
---

# /new-skill — Create a New Skill

Launch the `skill-creator` subagent:

1. Interview about the skill (workflow, trigger, context cost)
2. Scaffold: `skills/[name]/source/SKILL.md`, `manifest.yaml`, `summary.md`
3. Create native skill at `.claude/skills/[name]/SKILL.md`
4. Validate structure (readiness gate)
5. Register in `docs/registry/skill_index.yaml`
