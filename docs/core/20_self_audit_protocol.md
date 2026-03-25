# Self-Audit Protocol

Defines how the system verifies its own integrity. Prevents gradual degradation where files drift out of sync, references break, or components become orphaned.

---

## When to Run

- Every 5th session handoff (check `memory/metrics/effectiveness.md` row count)
- When the user says `/audit`
- After a major system modification (skill created, protocol updated)
- When something "feels off" -- references to files that don't exist, stale registry entries

## Audit Checklist

### 1. Registry Integrity

Verify that every entry in the registry indexes points to real files:

```
For each entry in docs/registry/skill_index.yaml:
  - Does skills/[name]/ directory exist?
  - Does skills/[name]/manifest.yaml exist?
  - Does skills/[name]/summary.md exist?
  - Does the source file referenced in manifest exist?
  - Does the manifest status match the registry status?

Repeat for framework_index.yaml and knowledge_index.yaml.
```

**Fix**: Remove orphaned entries, add unregistered components, correct mismatched statuses.

### 2. Cross-Reference Validity

Verify that file references in documentation are valid:

```
For each docs/core/ file:
  - Do all file path references point to existing files?
  - Do all cross-references to other protocols exist?

For CLAUDE.md:
  - Do all referenced files in the boot sequence exist?
  - Do all referenced files in Key References exist?
```

**Fix**: Update broken references, remove references to deleted files.

### 3. Dependency Map Accuracy

```
For each entry in docs/registry/dependency_map.md:
  - Do both the dependent and dependency still exist?
  - Are both still status: ready?
  - Does the manifest's dependencies field match the map?
```

**Fix**: Remove stale entries, add missing dependencies, sync manifests with map.

### 4. Active State Freshness

```
Check active/active_context.md:
  - Does it reflect actual current state?
  - Is the "Next Action" still relevant?
  - Are "Loaded Components" still needed?

Check active/active_issue.md:
  - If non-stub, is this issue still active?
  - Are attempted solutions current?

Check active/change_plan.md:
  - If non-stub, is this plan still in progress?
  - Has the plan been completed but not closed?
```

**Fix**: Clear stale active files, close completed plans, update stale context.

### 5. Memory File Health

```
Check memory/recent_deltas.md:
  - How many sessions of entries? (should be ≤ 3, rotate if more)

Check memory/progress_log.md:
  - How many entries? (rotate if > 10 sessions)

Check memory/known_issues.md:
  - Are there resolved issues that should be archived?
  - Are there ancient open issues that should be re-evaluated?

Check memory/metrics/effectiveness.md:
  - Is it being updated by retrospectives?

Check memory/metrics/pattern_journal.md:
  - Are there patterns at 3+ occurrences that should trigger skill creation?
```

**Fix**: Rotate oversized files, archive resolved issues, flag patterns for skill creation.

### 6. Skill Quality Check

For each skill with status `ready`:

```
Check last 3 uses in memory/metrics/effectiveness.md:
  - Was this skill used when relevant? (utilization)
  - Were its steps followed or skipped? (adherence)
  - Did work with this skill produce fewer issues? (effectiveness)
```

**Fix**: Simplify low-adherence skills, deprecate unused skills, improve low-effectiveness skills.

### 7. Protocol Weight Check

```
For each docs/core/ protocol:
  - How many lines? (flag if > 150 -- may need condensing)
  - Is it referenced in the cheatsheet? (if not, add it)
  - Is it referenced in any context profile? (if not, it may be orphaned)
```

**Fix**: Condense bloated protocols, update cheatsheet, evaluate orphaned protocols.

---

## Audit Report

Write findings to `memory/metrics/audit_log.md`:

```markdown
### Audit -- [date]

**Trigger**: scheduled | manual | post-modification
**Issues found**: [count]
**Issues fixed**: [count]

**Findings**:
- [finding and action taken]

**System health**: healthy | needs-attention | degraded
```

---

## Severity Levels

| Level | Examples | Action |
|-------|---------|--------|
| **Critical** | Broken boot sequence, missing CLAUDE.md references | Fix immediately |
| **Warning** | Stale active files, unrotated memory, orphaned registry entries | Fix during this audit |
| **Info** | Unused skills, slightly verbose protocols | Note for next retro |

## Safety

- The audit READS the system to check integrity. It does not make changes without reporting findings first.
- All fixes must be logged in `memory/change_log.md` with tag `[self-audit]`.
- If the audit finds conflicting information between files, report the conflict -- do not guess which is correct.
