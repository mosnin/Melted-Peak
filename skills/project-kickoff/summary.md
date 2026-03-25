# Project Kickoff -- Summary

Structured interview process that deeply understands what the user wants to build. Produces a comprehensive PRD document and seeds the entire Melted Peak memory system with foundational project context.

## When to Use
- Starting a new project
- User says `/kickoff`
- Melted Peak is added to a project with no existing context
- Major project pivot requiring re-evaluation

## Key Phases
1. **Discovery Interview**: 5 rounds, 15 question areas (vision, users, tech, architecture, scope)
2. **PRD Generation**: Writes `docs/prd.md` from interview answers
3. **Memory Seeding**: Populates active_context, project_state, architecture_decisions, feature_registry, dependency_map, progress_log
4. **Initial Skills**: Uses skill-router to suggest project-specific skills based on discovered patterns

## Interview Rounds
- **Round 1**: Vision and purpose (what, why, success criteria)
- **Round 2**: Users and experience (personas, workflows, anti-goals)
- **Round 3**: Technical landscape (stack, integrations, constraints)
- **Round 4**: Architecture and decisions (design, risks, data model)
- **Round 5**: Scope and priorities (MoSCoW, build order, v1 definition)

## Output
- `docs/prd.md` -- full product requirements document
- Seeded memory files across the system
- Suggested project-specific skills

## Best Practices
- One section at a time (don't dump all questions)
- Adapt to user's clarity level
- Push for specificity, capture uncertainty as "Open Questions"
- Summarize after each round to catch misunderstandings

## Context Cost
Medium -- the full SKILL.md contains the interview framework and PRD template.
