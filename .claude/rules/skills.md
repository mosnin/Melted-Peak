---
globs: "skills/**"
---

# Rules for Skills

- Every skill must have 3 files: `source/SKILL.md`, `manifest.yaml`, `summary.md`
- SKILL.md must have Purpose, Trigger, and Workflow sections
- Summary must be readable in under 60 seconds
- Manifest must have all required fields: name, version, status, description, context_cost, tags, triggers
- New skills must be registered in `docs/registry/skill_index.yaml`
- Also create a native Claude Code skill at `.claude/skills/[name]/SKILL.md` with frontmatter
- Update `docs/registry/dependency_map.md` if the skill has dependencies
