# Journey Report

## Purpose

Generate a narrative development history of a project by synthesizing all Melted Peak memory files — progress logs, change logs, recent deltas, resolved issues, and session handoffs. Produces a "Journey Into [Project]" document that tells the story of how the project was built.

## Trigger

- User asks for a project timeline, development history, or journey report
- Onboarding a new team member or session to a long-running project
- Retrospective that needs the full picture

## Workflow

### Step 1: Gather Sources

Read these files (skip any that are empty stubs):
- `memory/progress_log.md` — completed tasks chronologically
- `memory/change_log.md` — all system and code changes
- `memory/recent_deltas.md` — recent changes with observation types
- `memory/archive/resolved_issues.md` — past issues and their resolutions
- `memory/metrics/retrospectives.md` — lessons learned
- `memory/metrics/pattern_journal.md` — detected patterns
- `memory/metrics/audit_log.md` — system health over time

### Step 2: Estimate Scope

Report to the user:
- Date range (earliest to latest entry)
- Total entries across all files
- Estimated output length (1000-5000 words depending on history size)

Ask for confirmation if the history spans more than 20 sessions.

### Step 3: Analyze and Write

Generate a narrative report with these sections:

1. **Project Genesis** — When and how the project started. First decisions, initial architecture, founding constraints.

2. **Architectural Evolution** — How the architecture changed over time. Major pivots and why they happened. Trace from initial design through each restructuring.

3. **Key Milestones** — Major features shipped, hard bugs fixed, significant decisions made. Reference specific log entries with dates.

4. **Debugging Sagas** — The hardest problems. Multi-session debugging efforts, three-strike escalations, architectural dead-ends. What was tried, what failed, what finally worked.

5. **Patterns and Lessons** — Recurring themes from retrospectives and pattern journal. What the team learned about this codebase.

6. **System Evolution** — How the Melted Peak system itself evolved during this project (new skills, new knowledge packs, regression checklist growth).

7. **Statistics** — Date range, total sessions, issues resolved, skills used, observation type breakdown (if taxonomy tags are present).

### Step 4: Save

Save the report to `docs/reports/journey-[project-name]-[YYYY-MM-DD].md`.

### Step 5: Report

Tell the user where the report was saved, the date range covered, and number of entries analyzed.

## Writing Style

- Technical narrative, not bullet points
- Reference specific dates and entries
- Connect events across time — show how early decisions created later consequences
- Be honest about struggles and dead ends
- Target 2000-5000 words depending on project size

## Integration

- **Pairs with**: `/retro` — retrospective feeds lessons into the journey
- **Uses**: Observation taxonomy tags for analysis and statistics
- **Output**: `docs/reports/` directory
