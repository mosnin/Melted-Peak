# Example: Minimal Peak Structure

This shows the minimum viable structure for a custom peak. Use this as a starting point when creating domain-specific peaks with `/peak create`.

## Directory Structure

```
peaks/my-domain/
├── peak.yaml           # Required: manifest declaring what the peak provides
├── README.md           # Required: human-readable overview
├── conventions.md      # Recommended: domain conventions loaded on boot
├── skills/             # Optional: domain-specific skills
│   └── my-workflow/
│       ├── source/SKILL.md
│       ├── manifest.yaml
│       └── summary.md
├── knowledge/          # Optional: domain reference material
│   └── my-reference/
│       ├── source/
│       │   └── reference.md
│       ├── manifest.yaml
│       └── summary.md
├── templates/          # Optional: domain file templates
│   └── my_template.md
└── profiles/           # Optional: context compiler profiles
    └── my-work-type.yaml
```

## Minimal peak.yaml

```yaml
name: "my-domain"
version: "1.0.0"
status: "ready"
description: "One-line description of what this peak covers"
domain: "frontend"  # or backend, fullstack, agents, devops, mobile, data, security

provides:
  skills: [my-domain/my-workflow]
  knowledge: [my-domain/my-reference]
  templates: [my_template]
  profiles: [my-work-type]

stack:
  languages: [typescript]
  frameworks: [react]
  runtimes: [node]
  databases: []
  tools: []

requires:
  melted_peak_version: ">=1.0.0"
  peaks: []
  system: []

conflicts:
  peaks: []

context:
  boot_files: [conventions.md]
  work_type_extensions: {}
  custom_work_types:
    - name: my-work-type
      profile: profiles/my-work-type.yaml

tags: [my-domain, my-stack]
context_cost: "small"
created: "2026-01-01"
updated: "2026-01-01"
author: ""
source_url: ""
```

## Minimal Context Profile

```yaml
# profiles/my-work-type.yaml
work_type: my-work-type
description: "Doing domain-specific work"

required:
  - peaks/my-domain/conventions.md
  - peaks/my-domain/knowledge/my-reference/summary.md

recommended:
  - active/change_plan.md
```

## What Makes a Good Peak

1. **Self-contained**: A peak should work without requiring manual setup outside the peak directory
2. **Convention-first**: The `conventions.md` file should capture the most important rules upfront
3. **Summary-oriented**: Knowledge packs should have great summaries so the context compiler can load them efficiently
4. **Profile-aware**: Define context profiles so the compiler knows what to load for domain-specific work
5. **Composable**: Peaks should complement other peaks, not replace the core system
