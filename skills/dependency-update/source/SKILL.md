# Skill: Dependency Update

## Purpose
Safe workflow for updating project dependencies that prevents breaking changes and ensures compatibility.

## Trigger
- User requests a dependency update
- Security vulnerability found in a dependency
- New version of a dependency is needed for a feature
- Context compiler selects work type `maintenance`

## Workflow

### Phase 1: Assess

1. **Identify what needs updating**:
   - Which package/library?
   - Current version → target version
   - Why the update is needed (security, feature, compatibility)

2. **Read the changelog/release notes** for the target version:
   - Breaking changes?
   - Deprecated APIs?
   - New peer dependencies?
   - Migration guide available?

3. **Check dependency tree**:
   - What else depends on this package?
   - Will updating this force other updates?
   - Are there version conflicts?

4. **Risk assessment** -- write to `active/change_plan.md`:

   | Risk Factor | Low | Medium | High |
   |-------------|-----|--------|------|
   | Version jump | Patch (1.0.x) | Minor (1.x.0) | Major (x.0.0) |
   | API surface used | Few functions | Moderate usage | Core dependency |
   | Breaking changes listed | None | Deprecations | Removals/renames |
   | Test coverage | Well tested | Partially tested | Untested areas |

### Phase 2: Plan

5. **Write the change plan** in `active/change_plan.md`:
   - Package name and version change
   - Files that import/use the package (find all usages)
   - Required code changes for breaking changes
   - Rollback: `revert to previous lock file + package version`

6. **Write the validation plan** in `active/validation_plan.md`:
   - Run existing tests -- do they pass?
   - Run the application -- does it start?
   - Exercise features that use the updated dependency
   - Check for deprecation warnings in output

### Phase 3: Execute

7. **Create a snapshot**:
   - Commit current state (or note the commit hash for rollback)
   - Copy the current lock file as backup reference

8. **Update the dependency**:
   - Update the package specification
   - Run the package manager to resolve
   - Review lock file changes -- any unexpected transitive updates?

9. **Apply required code changes**:
   - Address breaking changes per the changelog
   - Update deprecated API calls
   - Update type definitions if needed

10. **Run validation**:
    - Execute the validation plan from step 6
    - Check `active/regression_checklist.md` for affected areas
    - Run the full test suite

### Phase 4: Document

11. **Update project records**:
    - `memory/dependency_map.md`: version, quirks, notes
    - `memory/change_log.md`: what was updated and why
    - `memory/recent_deltas.md`: files changed

12. **Update regression checklist** if the dependency touches sensitive areas

13. **Close the change plan** with outcome

## Rollback Procedure

If the update causes problems:
1. Revert to the pre-update commit (or restore lock file)
2. Reinstall dependencies from the reverted lock file
3. Verify the revert is clean (tests pass, app runs)
4. Document what went wrong in `active/active_issue.md ## Attempted Solutions`
5. Investigate the failure before retrying

## Critical Rules

- **Always read the changelog** before updating. Blind updates cause surprise breakage.
- **Never update multiple unrelated dependencies at once.** Update one at a time so failures are attributable.
- **Always have a rollback path.** Know the exact commit or lock file state to revert to.
- **Check transitive dependencies.** A library update may pull in new transitive deps that conflict.
- **Security updates get priority** but still follow this workflow. Fast doesn't mean sloppy.
