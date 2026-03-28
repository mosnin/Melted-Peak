# Seed Planting

## Purpose

Capture future ideas with structured trigger conditions so they resurface automatically at the right moment — not when you think of them, but when they become relevant.

## Trigger

- User mentions an idea that's out of scope for current work
- During debugging, you discover an improvement that doesn't belong in this fix
- During brainstorming, an idea emerges that's too big for the current plan
- Any "we should do X someday" moment

## Seed Format

Each seed is a file in `memory/seeds/` named `[YYYY-MM-DD]-[short-name].md`:

```markdown
# Seed: [Title]

**Planted**: [date]
**Status**: planted | sprouted | harvested | wilted

## Why

[Why this idea matters. What problem it solves. What value it creates.]

## When to Surface

[Trigger conditions — be specific. These are checked during /boot and /plan.]

- When working on: [specific area, feature, or file pattern]
- When issue type: [bug-fix in X, new feature in Y]
- At milestone: [after v1.0, after auth is complete]
- When pattern detected: [3rd time this workaround is used]

## Breadcrumbs

[Context that would be lost if you just wrote "do X later":]
- Related files: [paths]
- Related decisions: [ADR references]
- Current state: [what exists now that this would change]

## Notes

[Any additional context, rough approach ideas, constraints]
```

## Workflow

### Planting a Seed

1. Create a file in `memory/seeds/` using the format above
2. Set status to `planted`
3. Log in `active/active_context.md`: "Planted seed: [title]"
4. Continue with current work — do NOT act on the seed now

### Checking Seeds (during /boot and /plan)

1. Scan `memory/seeds/` for `planted` status seeds
2. Compare trigger conditions against current active issue and change plan
3. If a trigger matches: present the seed to the user
4. User decides: act now (harvest) or defer (keep planted)

### Harvesting a Seed

1. Update seed status to `harvested`
2. Create an issue or change plan from the seed content
3. The breadcrumbs section provides the starting context

### Wilting a Seed

If a seed is no longer relevant (approach changed, problem solved differently):
1. Update status to `wilted`
2. Add a note explaining why
3. Leave the file for history (don't delete)

## Integration

- **Planted by**: debugging skill (discovered improvements), brainstorming skill (deferred ideas), any skill that finds out-of-scope work
- **Checked by**: /boot (session start), /plan (before creating change plans)
- **Harvested into**: active_issue.md or change_plan.md
