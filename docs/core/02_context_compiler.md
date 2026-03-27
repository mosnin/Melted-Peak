# Context Compiler

The context compiler is a decision procedure for selecting the minimal relevant context for a given task. It is executed by the AI agent, not by software.

---

## When to Run

- At session start (after boot sequence)
- When the user describes a new task
- When the active issue changes
- When scope expands beyond the current context

## Process

### Step 1: Classify the Work

Determine the type of work from the user's request or the active issue:

| Work Type | Description |
|-----------|------------|
| `bug-fix` | Diagnosing and fixing a defect |
| `new-feature` | Building new functionality |
| `refactor` | Restructuring without behavior change |
| `investigation` | Research or analysis without code changes |
| `documentation` | Writing or updating docs |
| `ingestion` | Adding a new framework, skill, or knowledge pack |
| `maintenance` | Dependency updates, cleanup, housekeeping |
| `deployment` | Shipping code to staging or production |
| `security` | Security audit, vulnerability assessment |
| `onboarding` | Learning a new codebase or onboarding to a project |

### Step 2: Select Context Profile

Each work type has a pre-built context profile -- a set of files to load:

#### Bug-Fix Profile
```
Required:
  - active/active_issue.md
  - active/regression_checklist.md
  - docs/core/07_issue_isolation_protocol.md
  - docs/core/25_regression_prevention.md

Recommended:
  - Relevant framework summary (from registry)
  - memory/recent_deltas.md (for recent changes that may have caused the bug)
  - memory/known_issues.md (check if this is already known)
```

#### New-Feature Profile
```
Required:
  - active/active_issue.md
  - active/change_plan.md
  - docs/core/23_change_control_system.md

Recommended:
  - Relevant framework summary (from registry)
  - memory/feature_registry.md (avoid duplication)
  - memory/architecture_decisions.md (maintain consistency)
```

#### Refactor Profile
```
Required:
  - active/change_plan.md
  - active/regression_checklist.md
  - docs/core/23_change_control_system.md
  - docs/core/25_regression_prevention.md

Recommended:
  - memory/dependency_map.md (understand what depends on what)
  - Relevant framework summary
```

#### Investigation Profile
```
Required:
  - active/active_issue.md

Recommended:
  - Relevant knowledge pack summaries
  - memory/architecture_decisions.md
  - memory/progress_log.md (check if this was investigated before)
```

#### Ingestion Profile
```
Required:
  - docs/core/10_ingestion_and_normalization_rules.md
  - docs/core/11_readiness_gate.md
  - Relevant manifest template from docs/templates/

Recommended:
  - docs/registry/ indexes (check for conflicts)
```

#### Deployment Profile
```
Required:
  - active/change_plan.md
  - active/regression_checklist.md
  - skills/deployment-workflow/summary.md

Recommended:
  - memory/recent_deltas.md (what changed since last deploy)
  - memory/project_state.md (current state)
  - skills/testing-strategy/summary.md
```

#### Security Profile
```
Required:
  - skills/security-audit/summary.md

Recommended:
  - active/regression_checklist.md
  - memory/architecture_decisions.md
  - memory/dependency_map.md
```

#### Onboarding Profile
```
Required:
  - docs/core/12_knowledge_extraction_protocol.md
  - memory/architecture_decisions.md

Recommended:
  - memory/project_state.md
  - memory/feature_registry.md
  - docs/prd.md (if exists)
```

#### Session-Resume Profile
```
Required:
  - memory/session_handoff.md
  - active/active_context.md
  - active/active_issue.md

Recommended:
  - memory/recent_deltas.md
  - active/change_plan.md
  - active/validation_plan.md
```

### Step 3: Check Active Peaks

Read `peaks/active_peaks.yaml`. If peaks are mounted:

1. Read `peaks/active_profiles.yaml` for profile extensions and custom work types
2. **Extensions**: Append the peak's `add_required` and `add_recommended` files to the matching work-type profile from Step 2
3. **Custom work types**: If the classified work type matches a peak-provided custom type, use that profile instead of (or in addition to) the built-in profiles
4. **Boot files**: Peak boot files listed in `active_peaks.yaml` are loaded during boot, not during compilation (they're already in context)
5. **Conventions**: If the peak has a `conventions.md` and the work involves that peak's domain, add it to the required files

### Step 4: Resolve Dependencies

1. Read the relevant index file(s) from `docs/registry/` (including peak-provided components)
2. Identify components whose tags or descriptions match the task
3. Check `docs/registry/dependency_map.md` for required co-dependencies
4. For each relevant component, read the `manifest.yaml` to check:
   - `status` is `ready` (not `draft` or `deprecated`)
   - `context_cost` fits within available budget
   - `dependencies` are also loaded

### Step 5: Assemble Context

Build the context in priority order:

1. **Critical** -- active state files (always loaded)
2. **Peak conventions** -- active peak's conventions.md (if domain-relevant)
3. **Required** -- protocol files for this work type (including peak extensions)
4. **Summaries** -- component summaries, including peak-provided (small context cost)
5. **Full source** -- component source files (only when summary is insufficient)

### Step 6: Update Active Context

Write the assembled context to `active/active_context.md`:
- Current goal
- Work type classification
- Components loaded and why
- Current scope boundaries
- Next action

---

## Context Budget

The context window is finite. Use these guidelines:

| Context Cost | Approximate Size | Loading Rule |
|-------------|-----------------|-------------|
| `small` | < 500 lines | Load freely |
| `medium` | 500-2000 lines | Load summary first, source on demand |
| `large` | > 2000 lines | Load summary only; load source sections as needed |

When budget is tight:
- Prefer summaries over full source
- Prefer fewer, more relevant components over many tangential ones
- Drop `recommended` items before `required` items
- Never drop active state files

---

## Efficiency: Use the Cheat Sheet

When context is tight, load `docs/core/99_protocol_cheatsheet.md` instead of individual protocol files. It contains condensed versions of all protocols in a single file. Only load full protocol docs when you need the detailed procedures.

---

## Anti-Patterns

- Loading all frameworks "just in case" -- wastes context
- Loading full source when summary would suffice -- wastes context
- Not running the compiler when switching tasks -- causes stale context
- Ignoring `context_cost` in manifests -- leads to context overflow
- Loading full protocol docs when the cheat sheet would suffice -- wastes context
