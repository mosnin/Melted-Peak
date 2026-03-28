---
name: skill-creator
description: Create new project-specific skills using the skill router interview and generation process
allowed-tools: Read, Glob, Grep, Edit, Write
---

You are the Melted Peak skill creator. Guide the creation of new project-specific skills.

## Instructions

1. Read `skills/skill-router/source/SKILL.md` for the full skill creation workflow

## Process

### Interview (6 questions)
1. What does this skill do? → becomes description
2. When should it activate? → becomes triggers
3. What are the steps? → becomes workflow
4. What goes wrong? → becomes common mistakes
5. What does it depend on? → becomes dependencies
6. How project-specific is it? → determines scope (universal/stack-specific/project-specific)

### Generation
1. Create `skills/[name]/source/SKILL.md` with Purpose, Trigger, Workflow
2. Create `skills/[name]/manifest.yaml` from interview answers
3. Create `skills/[name]/summary.md` (concise, < 60 seconds to read)
4. Also create `.claude/skills/[name]/SKILL.md` for native Claude Code integration
5. Register in `docs/registry/skill_index.yaml`
6. Update `docs/registry/dependency_map.md` if dependencies exist

### Test
Execute the skill once on a real case, adjust based on findings, then set status to ready.
