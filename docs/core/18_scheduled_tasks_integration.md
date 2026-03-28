# Scheduled Tasks Integration

Defines how Melted Peak integrates with Claude Code's scheduled task system (/loop, cron) and channels for automated context maintenance.

## Session-Scoped Scheduling

Claude Code's /loop skill runs prompts on intervals during a session:

### Automated Context Maintenance
```
/loop 30m Check active/active_context.md. If the "Next Action" is stale (doesn't match current work), update it. Also check if memory/recent_deltas.md needs new entries for changes made since last check.
```

### Automated Regression Monitoring
```
/loop 1h Read active/regression_checklist.md. For each entry, verify the sensitive area hasn't been modified without verification. Report any unverified changes.
```

### Pattern Detection Loop
```
/loop 1h Check memory/metrics/pattern_journal.md. Are there any patterns with 3+ occurrences? If so, suggest creating a skill via the skill router.
```

### Memory Rotation Check
```
/loop 2h Check memory file sizes per docs/core/04_memory_rotation_protocol.md. Archive entries that exceed limits.
```

## One-Time Reminders

```
remind me in 45 minutes to run /handoff before I stop working
```

```
in 2 hours, run /audit to check system integrity
```

## Channel Integration

Channels push events into running sessions from external sources. Melted Peak can use channels for:

### CI/CD Event Processing
When a CI pipeline result arrives via channel, Melted Peak should:
1. Check if the result relates to the active change plan
2. Update active/active_context.md with the result
3. If tests failed, run the debugging skill

### External Issue Notifications
When a new issue is reported via channel:
1. Log to memory/known_issues.md
2. Do NOT switch from current active issue (issue isolation protocol)
3. Inform the user of the new issue

### Deployment Status Updates
When a deployment status arrives:
1. Update memory/project_state.md
2. If deployment failed, trigger incident-response skill

## Best Practices

- Use /loop for recurring checks within a session
- Use channels for external event-driven triggers
- Always respect issue isolation -- external events don't change focus
- Schedule /handoff reminders for long sessions
- Use /loop to enforce periodic context updates
