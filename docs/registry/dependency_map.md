# Component Dependency Map

Maps relationships between Melted Peak components. Used by the context compiler to ensure co-dependencies are loaded together.

## How to Read

- `A → B` means A depends on B (loading A requires also loading B)
- `A ↔ B` means A and B are mutually dependent

## Current Dependencies

### skills/project-kickoff
- Depends on: skills/skill-router
- Reason: Phase 4 of project kickoff uses the skill router to generate initial project-specific skills from patterns discovered during the interview

### skills/peak-manager
- Depends on: skills/skill-router
- Reason: Peak creation workflow uses the skill router to generate domain-specific skills within the peak
