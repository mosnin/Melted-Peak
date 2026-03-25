# Peak System

Peaks are comprehensive, importable sub-systems that plug into Melted Peak. Each peak is a domain-specific engineering context package -- frontend, backend, agent orchestration, DevOps, mobile, etc.

A peak is more than a framework. It is a **self-contained engineering context** that brings its own:
- Skills (workflows specific to that domain)
- Knowledge (reference material, patterns, best practices)
- Context profiles (how the context compiler should behave for this domain)
- Templates (file templates specific to this domain)
- Conventions (naming, structure, patterns the domain expects)

---

## What Is a Peak

Think of Melted Peak as an operating system. Peaks are like **application packages** that install into it:

| Concept | OS Analogy | Melted Peak |
|---------|-----------|-------------|
| Base system | Operating system | Melted Peak core (docs/core/, active/, memory/) |
| Application | Installed app | A Peak (e.g., `peaks/nextjs-frontend/`) |
| App provides | Features, menus, shortcuts | Skills, knowledge, context profiles, templates |
| App registry | Package manager | `docs/registry/peak_index.yaml` |
| Compatibility | System requirements | Peak manifest declares requirements + conflicts |

## Peak vs. Framework

| | Framework | Peak |
|--|-----------|------|
| **Size** | Single concern | Comprehensive domain |
| **Contains** | Source + manifest + summary | Skills + knowledge + profiles + templates + conventions |
| **Context impact** | Adds one component | Extends the entire system for a domain |
| **Provides skills** | No | Yes -- domain-specific workflows |
| **Modifies compiler** | No | Yes -- adds context profiles for its domain |
| **Examples** | "Testing strategy", "Error handling patterns" | "Next.js Frontend", "FastAPI Backend", "LangGraph Agents" |

---

## Peak Structure

Every peak lives in `peaks/[peak-name]/` and must contain:

```
peaks/[peak-name]/
├── peak.yaml                    # Peak manifest (required)
├── README.md                    # Human-readable overview (required)
├── skills/                      # Domain-specific skills (optional)
│   └── [skill-name]/
│       ├── source/SKILL.md
│       ├── manifest.yaml
│       └── summary.md
├── knowledge/                   # Domain reference material (optional)
│   └── [knowledge-name]/
│       ├── source/
│       ├── manifest.yaml
│       └── summary.md
├── templates/                   # Domain file templates (optional)
│   └── [template-name].md|yaml
├── profiles/                    # Context compiler profiles (optional)
│   └── [profile-name].yaml
└── conventions.md               # Domain conventions and patterns (optional)
```

## Peak Manifest (`peak.yaml`)

```yaml
name: ""                          # Unique identifier (lowercase, hyphens)
version: "1.0.0"                  # Semantic versioning
status: "draft"                   # draft | ready | deprecated | superseded
description: ""                   # One-line summary
domain: ""                        # Primary domain: frontend | backend | fullstack |
                                  # agents | devops | mobile | data | security

# What this peak provides
provides:
  skills: []                      # List of skill names provided
  knowledge: []                   # List of knowledge pack names provided
  templates: []                   # List of template names provided
  profiles: []                    # List of context profile names provided

# Tech stack this peak is designed for
stack:
  languages: []                   # e.g., [typescript, python]
  frameworks: []                  # e.g., [nextjs, react]
  runtimes: []                    # e.g., [node, deno, bun]
  databases: []                   # e.g., [postgres, redis]
  tools: []                       # e.g., [docker, terraform]

# Requirements and compatibility
requires:
  melted_peak_version: ">=1.0.0"  # Minimum MP version
  peaks: []                       # Other peaks that must be mounted
  system: []                      # System requirements (e.g., node >= 18)

conflicts:
  peaks: []                       # Peaks that cannot coexist
                                  # e.g., [nextjs-frontend] conflicts with [remix-frontend]

# Context compiler integration
context:
  boot_files: []                  # Files to read during boot when this peak is active
  work_type_extensions: {}        # Additional profiles for existing work types
  custom_work_types: []           # New work types this peak introduces

# Metadata
tags: []
context_cost: "medium"            # Overall cost when peak is fully loaded
created: ""
updated: ""
author: ""
source_url: ""                    # Where the peak came from (git repo, etc.)
```

---

## Mounting a Peak

Mounting is the process of integrating a peak into the active Melted Peak system. It is more involved than regular component ingestion because a peak touches multiple parts of the system.

### Mount Procedure

See `skills/peak-manager/source/SKILL.md` for the full workflow.

Quick summary:
1. Place peak in `incoming/` or directly in `peaks/[name]/`
2. Validate structure (peak.yaml, required files)
3. Check compatibility (conflicts, requirements)
4. Register provided components into main registries
5. Merge context profiles into the compiler
6. Update `docs/registry/peak_index.yaml`
7. Update boot sequence if peak declares boot files
8. Set status to `ready`

### Unmounting a Peak

1. Remove peak's components from main registries
2. Remove peak's context profiles from compiler
3. Remove peak's boot files from boot sequence
4. Set status to `unmounted` in peak registry
5. Peak directory can remain (for re-mounting) or be deleted

---

## Dynamic Integration

When a peak is mounted, it dynamically extends the system:

### Context Compiler Extensions

A peak can extend existing work-type profiles:

```yaml
# peaks/nextjs-frontend/profiles/bug-fix-extension.yaml
extends: bug-fix
add_required:
  - peaks/nextjs-frontend/knowledge/react-patterns/summary.md
add_recommended:
  - peaks/nextjs-frontend/knowledge/nextjs-routing/summary.md
```

Or introduce entirely new work types:

```yaml
# peaks/nextjs-frontend/profiles/component-creation.yaml
work_type: component-creation
description: "Creating a new React/Next.js component"
required:
  - active/active_issue.md
  - active/change_plan.md
  - peaks/nextjs-frontend/conventions.md
  - peaks/nextjs-frontend/knowledge/react-patterns/summary.md
recommended:
  - peaks/nextjs-frontend/templates/component.tsx
  - peaks/nextjs-frontend/knowledge/testing-components/summary.md
```

### Skill Registration

Peak skills are registered in the main skill index with a namespace prefix:

```yaml
# In docs/registry/skill_index.yaml (auto-added during mount)
- name: nextjs-frontend/component-scaffold
  path: peaks/nextjs-frontend/skills/component-scaffold/
  status: ready
  context_cost: small
  tags: [frontend, react, nextjs, component]
  triggers: [new-component, work-type-component-creation]
  description: Scaffold a new Next.js component with tests and stories
  peak: nextjs-frontend    # <-- identifies this as peak-provided
```

### Convention Injection

If a peak includes `conventions.md`, its conventions are loaded when the peak's domain is relevant:
- Frontend peak conventions loaded during frontend work
- Backend peak conventions loaded during API/database work
- The context compiler checks the active peak's domain against the work type

---

## Peak Compatibility

### Conflict Rules

- Two peaks with the same `domain` CAN coexist (e.g., a React knowledge peak + a CSS peak)
- Two peaks that declare each other in `conflicts.peaks` CANNOT coexist
- Conflicts are checked during mounting -- the mount fails with a clear message
- The user must unmount the conflicting peak first

### Dependency Resolution

If Peak A `requires.peaks: [peak-b]`:
1. Check if Peak B is mounted and `ready`
2. If not mounted, inform the user and offer to mount it
3. If mounted but not `ready`, block until it is

---

## Peak Discovery

Peaks can come from:
- The user providing files directly (copy into `incoming/`)
- A git repository URL (the peak manager skill clones it)
- A curated peak catalog (future: community peaks)

The peak manager skill handles all import methods.
