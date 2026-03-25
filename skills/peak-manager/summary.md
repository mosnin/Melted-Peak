# Peak Manager -- Summary

Manages the full lifecycle of peaks -- comprehensive domain-specific sub-systems (frontend, backend, agents, etc.) that extend Melted Peak with domain skills, knowledge, templates, context profiles, and conventions.

## When to Use
- User says `/peak import`, `/peak mount`, `/peak unmount`, `/peak list`, `/peak create`
- User provides a peak package or documentation for a domain
- Setting up a project with specific tech stack requirements

## Commands
| Command | Action |
|---------|--------|
| `/peak import [source]` | Import from files or directory |
| `/peak mount [name]` | Activate an imported peak |
| `/peak unmount [name]` | Deactivate a peak (reversible) |
| `/peak list` | Show all peaks and status |
| `/peak create` | Interview-driven peak creation |

## Key Workflows
1. **Import**: Validate structure, check manifest, stage in `peaks/[name]/`
2. **Mount**: Conflict check → dependency check → register components → merge profiles → update boot → mark ready
3. **Unmount**: Dependency check → deregister components → remove profiles → mark unmounted
4. **Create**: Interview domain/stack/workflows → generate peak structure → mount

## Safety
- Conflicts enforced (cannot mount conflicting peaks)
- Core files never modified (peaks use overlay files)
- All operations logged with `[peak-mount]`/`[peak-unmount]` tags
- Unmounting is fully reversible

## Context Cost
Medium -- the full skill covers import, mount, unmount, create, and update workflows.
