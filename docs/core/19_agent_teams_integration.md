# Agent Teams Integration

Defines how Melted Peak works with Claude Code's agent teams feature for coordinated parallel work.

## When to Use Agent Teams

Agent teams are best for:
- Parallel code review (security, performance, tests each assigned to different teammate)
- Multi-module feature work (frontend, backend, tests each owned by a teammate)
- Competing hypothesis debugging (multiple theories investigated simultaneously)
- Large-scale refactoring across independent modules

Agent teams are NOT for:
- Sequential tasks with dependencies
- Work that touches the same files
- Simple tasks a single session handles well

## Melted Peak + Agent Teams

### Context for Teammates

Each teammate loads CLAUDE.md and .claude/skills/ automatically. They also get:
- Path-scoped rules from .claude/rules/ when working in specific directories
- Access to all Melted Peak skills via /skill-name
- Active peaks and their conventions

Teammates do NOT inherit:
- The lead's conversation history
- The lead's active_context.md state (they start fresh)

### Task List Integration

Agent teams use a shared task list. Map Melted Peak change plan steps to tasks:

1. Write the change plan in active/change_plan.md
2. Ask the lead to create a team with one task per change plan step
3. Each teammate claims a task and works independently
4. Parent updates active_context.md and recent_deltas.md after synthesis

### Parallel Audit

Use agent teams for comprehensive audits:
```
Create an agent team to audit Melted Peak:
- Teammate 1: Registry integrity (skill_index, knowledge_index, peak_index)
- Teammate 2: Cross-reference validity (all file references in docs/core/)
- Teammate 3: Skill quality (verify all 30 skills have complete files)
- Teammate 4: Memory health (check all memory/ files for staleness)
Have each teammate report findings, then synthesize.
```

### Parallel Feature Build

For features spanning multiple areas:
```
Create a team to implement the user dashboard:
- Teammate 1 (frontend): Build the dashboard UI components
- Teammate 2 (backend): Build the API endpoints and data layer
- Teammate 3 (tests): Write tests for both frontend and backend
Each teammate should read peaks/modaf-saas/conventions.md first.
Require plan approval before implementation.
```

### Quality Gates with Hooks

Use Melted Peak hooks with agent teams:
- TeammateIdle hook: check if the teammate updated active files
- TaskCompleted hook: verify the task matches the change plan step
- TaskCreated hook: ensure tasks align with the scope in active_context.md

## Best Practices

1. Give teammates the spawn prompt with task-specific context
2. Keep team size to 3-5 teammates (diminishing returns beyond that)
3. Avoid file conflicts -- each teammate owns different files
4. Use the lead to update shared Melted Peak files (registries, active state)
5. Run /retro after team work completes
6. Monitor teammate progress and redirect if needed
