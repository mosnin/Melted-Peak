# Skill: Retrospective

## Purpose
Post-completion analysis that extracts lessons from completed work and feeds them back into the system. This is the primary self-improvement mechanism -- every completed issue makes the system smarter.

## Trigger
- After resolving an issue (especially difficult ones)
- After completing a feature
- User says `/retro`
- End of a multi-session piece of work
- After the three-strike rule was invoked

---

## Workflow

### Step 1: Gather Evidence

Read these files to reconstruct what happened:
- `active/active_issue.md` -- the problem and all attempted solutions
- `active/change_plan.md` -- what was planned vs. what happened
- `memory/recent_deltas.md` -- all changes made
- `memory/change_log.md` -- recent entries for this work
- `active/regression_checklist.md` -- any new sensitive areas found

### Step 2: Analyze Effectiveness

Answer these questions honestly:

#### What went well?
- Did the change plan match reality? (If yes, planning is working)
- Was the root cause found quickly? (If yes, diagnosis skills are good)
- Were there zero regressions? (If yes, regression prevention is working)

#### What went wrong?
- How many fix attempts were needed? (1 = great, 2 = ok, 3+ = analyze why)
- Did the scope expand during work? (If yes, initial assessment missed something)
- Were any skills or protocols skipped? (If yes, why? Too heavy? Not relevant?)
- Was context missing that would have helped? (If yes, context compiler needs updating)

#### What was surprising?
- Unexpected dependencies discovered
- Files that were sensitive but not on the regression checklist
- Patterns that repeated from previous work
- Knowledge gaps that slowed progress

### Step 3: Feed Back Into the System

Based on the analysis, update these files:

#### Always Update:
- **`active/regression_checklist.md`**: Add any new sensitive areas discovered
- **`memory/architecture_decisions.md`**: Record any design insights gained
- **`memory/metrics/effectiveness.md`**: Log the outcome metrics (see Metrics section)

#### Update If Applicable:

| Finding | Action |
|---------|--------|
| A skill's steps were wrong or incomplete | Update the skill's SKILL.md |
| A skill was consistently skipped | Consider if it's too heavy -- simplify or split |
| Context was missing for this work type | Update the context compiler profile |
| Same pattern repeated 3+ times | Trigger the skill router to create a new skill |
| A protocol was too rigid for this case | Add an exception clause to the protocol |
| An architecture decision was wrong | Update the ADR with new status and lessons |
| A knowledge gap slowed work | Create a knowledge pack or note for ingestion |

#### Guarded Updates (require user confirmation):
- Modifying any `docs/core/` protocol file
- Changing a skill that other skills depend on
- Modifying context compiler profiles

### Step 4: Write the Retrospective Entry

Append to `memory/metrics/retrospectives.md`:

```markdown
### [date] -- [issue/feature title]

**Outcome**: resolved | partial | abandoned
**Attempts**: [number of fix attempts]
**Sessions**: [number of sessions this took]
**Scope drift**: none | minor | major

**What worked**:
-

**What didn't**:
-

**System improvements made**:
-

**Open improvements** (deferred):
-
```

### Step 5: Check for Systemic Patterns

Read the last 5 retrospective entries. Look for:

- **Recurring failure modes**: Same type of mistake keeps happening → need a guard rail or skill
- **Consistently skipped protocols**: A protocol is too heavy or poorly timed → simplify it
- **Growing regression checklist**: System is learning, but are old entries still valid?
- **Scope drift pattern**: Estimates are consistently wrong → improve the assessment phase

If a systemic pattern is found, log it in `memory/metrics/system_health.md` and suggest a specific improvement to the user.

---

## Metrics Section

### What to Track

Log each completed issue/feature in `memory/metrics/effectiveness.md`:

```markdown
| Date | Issue | Attempts | Sessions | Scope Drift | Regressions | Skills Used | Skipped |
|------|-------|----------|----------|-------------|-------------|-------------|---------|
```

Over time this table reveals:
- **Average attempts per fix** -- should trend down as the system learns
- **Regressions per change** -- should trend toward zero
- **Skills usage** -- which skills are valuable, which are ignored
- **Scope drift frequency** -- whether planning is improving

### Health Indicators

| Metric | Healthy | Warning | Critical |
|--------|---------|---------|----------|
| Avg fix attempts | 1-2 | 3 | 4+ |
| Regressions per 10 changes | 0-1 | 2-3 | 4+ |
| Scope drift rate | < 20% | 20-50% | > 50% |
| Protocols skipped | < 10% | 10-30% | > 30% |
| Three-strike invocations | Rare | Monthly | Weekly |

---

## Safety Rules

The retrospective skill can suggest changes to the system itself. To prevent degradation:

1. **Never auto-modify protocols.** All protocol changes require user confirmation.
2. **Log every system modification** in `memory/change_log.md` with tag `[system-self-improvement]`.
3. **One improvement at a time.** Don't batch multiple system changes -- apply one, observe, then consider the next.
4. **Reversibility.** Every improvement must have a clear rollback path. If a skill update makes things worse, revert to the previous version.
5. **Validate the improvement.** After modifying a skill or protocol, the next time it's used, explicitly check: "Did this change help?"
