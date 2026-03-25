# Skill Router -- Summary

Meta-skill that makes Melted Peak self-evolving. Detects repeated workflow patterns in the project and guides the creation of new project-specific skills through a structured interview and generation process.

## When to Use
- User says `/new-skill`
- A workflow has been repeated 3+ times
- A process is error-prone and would benefit from a checklist
- During retrospective when reusable patterns are identified

## Key Steps
1. **Detect**: Recognize repeated sequences, error-prone processes, or complex procedures
2. **Interview**: 6 questions covering purpose, triggers, steps, failure modes, dependencies, scope
3. **Generate**: Create SKILL.md, manifest.yaml, summary.md from interview answers
4. **Register**: Add to skill_index.yaml and dependency_map.md
5. **Test**: Execute the skill once on a real case, adjust based on findings
6. **Promote**: Set status to `ready` after successful test

## Skill Scope Levels
- **Universal**: Works in any project
- **Stack-specific**: Works for projects with the same tech stack
- **Project-specific**: Only works in this exact project

## Pattern Signals
- Same file sequence touched repeatedly → scaffolding skill
- Same checks run before an action → checklist skill
- Complex multi-step procedure → procedure skill
- Repeated mistakes in a process → guard-rail skill

## Context Cost
Medium -- the full SKILL.md includes the interview framework and generation templates.
