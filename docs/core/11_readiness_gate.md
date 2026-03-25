# Readiness Gate

Defines when a component is allowed to be used in active work. Prevents incomplete or low-quality components from entering the system.

---

## Gate Criteria

A component passes the readiness gate when ALL of the following are true:

### Structural Requirements

- [ ] Source file(s) exist and are non-empty
- [ ] `manifest.yaml` exists with all required fields populated
- [ ] `summary.md` exists and is readable in under 60 seconds
- [ ] Component is in the correct directory (`frameworks/`, `skills/`, or `knowledge/`)
- [ ] Component is NOT in `incoming/`

### Manifest Requirements

- [ ] `name` is unique across all registry indexes
- [ ] `version` follows semantic versioning
- [ ] `status` is set to `ready` (not `draft` or `deprecated`)
- [ ] `description` is a clear one-line summary
- [ ] `context_cost` is set to `small`, `medium`, or `large`
- [ ] `dependencies` lists all required co-components (or is empty)
- [ ] `tags` contains at least one tag

### Content Requirements

- [ ] Source material is self-contained (no broken external references)
- [ ] Summary accurately reflects the source content
- [ ] For skills: `SKILL.md` defines a clear, executable workflow
- [ ] For frameworks: source is organized into navigable sections
- [ ] For knowledge: reference material is accurate and current

### Registry Requirements

- [ ] Component is listed in the appropriate registry index
- [ ] Dependencies are listed in `docs/registry/dependency_map.md` (if any)
- [ ] All listed dependencies also pass the readiness gate

---

## Status Lifecycle

```
incoming → draft → ready → deprecated
                     ↓
                  superseded
```

| Status | Meaning | Can Be Used? |
|--------|---------|-------------|
| (in `incoming/`) | Raw, unnormalized | No |
| `draft` | Normalized but not verified | No |
| `ready` | Verified and approved | Yes |
| `deprecated` | Replaced or outdated | No (warn if referenced) |
| `superseded` | Replaced by a newer version | No (redirect to replacement) |

## Enforcement

- The context compiler MUST check `status: ready` before loading a component
- If a `draft` component is needed urgently, the user must explicitly approve its use and the risk must be noted in `active/active_context.md`
- `deprecated` components should trigger a warning and a suggestion to update
- `superseded` components should redirect to the replacement listed in the manifest

## Verification Procedure

To verify a component's readiness:

1. Read the `manifest.yaml` -- check all required fields
2. Read the `summary.md` -- verify it's clear and accurate
3. Spot-check the source -- verify it's organized and self-contained
4. Check the registry -- verify the component is indexed
5. Check dependencies -- verify all dependencies are also `ready`
6. Update status to `ready` if all checks pass
