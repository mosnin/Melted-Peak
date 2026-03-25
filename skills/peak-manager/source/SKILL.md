# Skill: Peak Manager

## Purpose
Import, mount, unmount, and manage peaks -- comprehensive domain-specific sub-systems that extend Melted Peak for frontend, backend, agent orchestration, and other engineering domains.

## Trigger
- User says `/peak import [source]`
- User says `/peak mount [name]`
- User says `/peak unmount [name]`
- User says `/peak list`
- User says `/peak status`
- User provides a peak package for integration

---

## Commands

| Command | Action |
|---------|--------|
| `/peak import [source]` | Import a peak from files, directory, or URL |
| `/peak mount [name]` | Activate an imported peak |
| `/peak unmount [name]` | Deactivate a mounted peak |
| `/peak list` | Show all peaks and their status |
| `/peak status [name]` | Show detailed status of a specific peak |
| `/peak update [name]` | Update a peak to a newer version |
| `/peak create` | Start creating a new custom peak |

---

## Workflow: Import a Peak

### Step 1: Receive Peak Source

Accept the peak from one of these sources:

| Source | Method |
|--------|--------|
| Local files | User places files in `incoming/peaks/[name]/` |
| Directory | User provides a path to a peak directory |
| Raw documentation | User provides docs to be structured into a peak |

### Step 2: Validate Structure

Check that the peak has the minimum required files:

```
Required:
  ✓ peak.yaml           -- peak manifest
  ✓ README.md            -- human-readable overview

Optional but expected:
  ○ skills/              -- domain-specific skills
  ○ knowledge/           -- domain reference material
  ○ templates/           -- domain file templates
  ○ profiles/            -- context compiler profiles
  ○ conventions.md       -- domain conventions and patterns
```

If `peak.yaml` is missing, offer to create it by interviewing the user:
1. What domain does this cover?
2. What tech stack is it for?
3. What skills/knowledge does it provide?
4. Does it conflict with any existing peaks?

### Step 3: Validate Manifest

Check `peak.yaml` for:
- All required fields are populated
- `name` is unique (not in `docs/registry/peak_index.yaml` already)
- `domain` is a recognized domain
- `provides` lists match actual files in the peak directory
- `requires` and `conflicts` reference valid peaks

### Step 4: Stage the Peak

Move or copy the peak to `peaks/[name]/` with status `draft`.

Report to user:
- Peak name, version, domain
- What it provides (skills, knowledge, templates, profiles)
- Requirements and conflicts
- Estimated context cost

Ask: "Ready to mount this peak?"

---

## Workflow: Mount a Peak

Mounting activates a peak and integrates its components into the live system.

### Step 1: Pre-Flight Checks

1. **Conflict detection**:
   - Read `docs/registry/peak_index.yaml`
   - For each mounted peak, check if its `conflicts.peaks` list contains this peak's name
   - Check if this peak's `conflicts.peaks` list contains any mounted peak
   - If conflict found: STOP and inform user which peaks conflict

2. **Dependency resolution**:
   - Check `requires.peaks` -- are all required peaks mounted and `ready`?
   - If a required peak is not mounted: inform user, offer to mount it first
   - Check `requires.system` -- are system requirements met?

3. **Stack compatibility** (advisory, not blocking):
   - Check if this peak's stack matches the project's known stack (from `memory/project_state.md` or PRD)
   - If mismatch: warn but allow (user knows best)

### Step 2: Register Components

For each component the peak provides:

#### Skills
For each skill in `peaks/[name]/skills/`:
1. Validate it has the standard three files (SKILL.md, manifest.yaml, summary.md)
2. Add entry to `docs/registry/skill_index.yaml` with namespace: `[peak-name]/[skill-name]`
3. Set `peak: [peak-name]` field in the registry entry
4. Update `docs/registry/dependency_map.md` if the skill has dependencies

#### Knowledge
For each knowledge pack in `peaks/[name]/knowledge/`:
1. Validate three files (source/, manifest.yaml, summary.md)
2. Add entry to `docs/registry/knowledge_index.yaml` with namespace: `[peak-name]/[knowledge-name]`
3. Set `peak: [peak-name]` field

#### Templates
For each template in `peaks/[name]/templates/`:
- Templates remain in the peak directory (not copied to `docs/templates/`)
- They are referenced by peak skills and profiles using relative paths

### Step 3: Merge Context Profiles

For each profile in `peaks/[name]/profiles/`:

#### Extension Profiles (extend existing work types)
```yaml
extends: bug-fix
add_required:
  - peaks/[name]/knowledge/something/summary.md
add_recommended:
  - peaks/[name]/conventions.md
```

Read the current context compiler profiles. Append the peak's additions to the appropriate work type profile. Log the extension in `memory/change_log.md` with tag `[peak-mount]`.

#### Custom Work Types
```yaml
work_type: component-creation
description: "Creating a new component"
required:
  - [file list]
recommended:
  - [file list]
```

Add the new work type to the context compiler's work type table. This is done by updating `docs/core/02_context_compiler.md` or by maintaining a separate `peaks/active_profiles.yaml` that the compiler reads.

**Preferred approach**: Maintain a `peaks/active_profiles.yaml` file that the context compiler checks after its built-in profiles. This avoids modifying core protocol files during peak operations.

### Step 4: Configure Boot Files

If the peak declares `context.boot_files`:
- These files are read during boot ONLY when the peak is mounted
- Add them to `peaks/active_peaks.yaml` (the peak boot registry)
- The boot sequence reads `peaks/active_peaks.yaml` after the standard boot files

### Step 5: Update Registries

1. Add/update entry in `docs/registry/peak_index.yaml`
2. Set status to `ready`
3. Log mount in `memory/change_log.md` with tag `[peak-mount]`
4. Update `memory/project_state.md` with peak info

### Step 6: Report

Tell the user:
- Peak mounted successfully
- Components registered: N skills, N knowledge packs, N templates, N profiles
- New work types available (if any)
- Conventions file loaded (if any)

---

## Workflow: Unmount a Peak

### Step 1: Dependency Check

Are any other mounted peaks dependent on this one?
- If yes: inform user, require them to unmount dependents first or force-unmount

### Step 2: Deregister Components

1. Remove peak's skills from `docs/registry/skill_index.yaml` (entries with `peak: [name]`)
2. Remove peak's knowledge from `docs/registry/knowledge_index.yaml`
3. Remove peak's entries from `docs/registry/dependency_map.md`

### Step 3: Remove Context Profiles

1. Remove peak's extensions from active profiles
2. Remove custom work types
3. Remove boot files from `peaks/active_peaks.yaml`

### Step 4: Update Registry

1. Set peak status to `unmounted` in `docs/registry/peak_index.yaml`
2. Log unmount in `memory/change_log.md` with tag `[peak-unmount]`
3. Update `memory/project_state.md`

Peak directory remains in `peaks/` for potential re-mounting. To fully remove:
- Delete `peaks/[name]/` directory
- Remove entry from `docs/registry/peak_index.yaml`

---

## Workflow: Create a Custom Peak

Use this when the user wants to create a peak for their specific project or stack.

### Interview

1. **What domain?** (frontend, backend, agents, fullstack, etc.)
2. **What stack?** (languages, frameworks, tools)
3. **What workflows are specific to this domain?** → become skills
4. **What reference material is needed?** → becomes knowledge
5. **What file templates are commonly used?** → become templates
6. **What conventions should be followed?** → becomes conventions.md
7. **What context should be loaded for different work types?** → become profiles

### Generation

1. Create `peaks/[name]/` directory structure
2. Generate `peak.yaml` from interview answers
3. Write `README.md`
4. For each skill identified: run the skill router to create it within `peaks/[name]/skills/`
5. For each knowledge area: create source + manifest + summary within `peaks/[name]/knowledge/`
6. For each template: create the template file
7. Write `conventions.md` from conventions discussed
8. Create context profiles from work type discussion
9. Run the mount workflow to activate

---

## Safety Rules

1. **Peak operations are logged.** Every mount/unmount is recorded in `memory/change_log.md`.
2. **Conflicts are enforced.** The system will not mount conflicting peaks.
3. **Core files are not modified.** Peaks extend the system through overlay files (`peaks/active_peaks.yaml`, `peaks/active_profiles.yaml`), not by modifying `docs/core/` files.
4. **Unmounting is clean.** All registrations are reversed. No orphaned entries.
5. **Version tracking.** Peak versions are tracked for upgrade paths.
