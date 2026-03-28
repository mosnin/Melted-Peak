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

## Skill Description Rules (Claude Search Optimization)

The `description` field in `.claude/skills/[name]/SKILL.md` frontmatter is critical for skill discovery. Follow these rules:

- **Descriptions describe WHEN to use, not WHAT the skill does**
- Start with "Use when..." to focus on triggering conditions
- Include concrete symptoms, situations, and contexts that signal the skill applies
- NEVER summarize the skill's process or workflow in the description — Claude may follow the description instead of reading the full skill body
- Keep under 500 characters

```yaml
# BAD: Summarizes workflow — Claude may skip reading the skill body
description: Dispatches subagents per task with two-stage spec and quality review

# GOOD: Triggering conditions only
description: Use when executing implementation plans with independent tasks that can run in sequence
```

## Token Efficiency Targets

Skills loaded frequently must be concise:
- **Boot skills / frequently-loaded**: < 200 words total
- **Other skills**: < 500 words preferred
- Move heavy reference material to separate files, not inline
- One excellent code example beats multiple mediocre ones
- Use tables and quick-reference sections for scannable content

## Rationalization Tables

For discipline-enforcing skills (TDD, verification, change plans), include a Rationalization Table section that explicitly names common excuses and counters them. This is the most effective way to prevent agents from finding loopholes.
