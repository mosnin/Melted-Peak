# Project Integration Guide

Defines how to embed Melted Peak into an existing project that already has its own CLAUDE.md.

---

## The Problem

Claude Code reads one `CLAUDE.md` per directory (plus parent directories). When Melted Peak is added to a project, both the project's rules and Melted Peak's rules must be active.

## Strategy: Melted Peak as Subdirectory

Place Melted Peak in a subdirectory (e.g., `.melted-peak/` or `melted-peak/`) and reference it from the project's CLAUDE.md.

### Directory Structure
```
my-project/
├── CLAUDE.md                  # Project CLAUDE.md (modified to include MP)
├── .melted-peak/              # Melted Peak system
│   ├── CLAUDE.md              # MP operating rules (read via include)
│   ├── active/
│   ├── memory/
│   ├── docs/
│   ├── frameworks/
│   ├── skills/
│   ├── knowledge/
│   └── incoming/
├── src/                       # Project code
└── ...
```

### How to Merge

Add this block to the **top** of the project's existing CLAUDE.md:

```markdown
# Melted Peak Integration

This project uses the Melted Peak Engineering Context Operating System.
Read and follow `.melted-peak/CLAUDE.md` for context management rules.

All Melted Peak file paths are relative to `.melted-peak/`.
For example, `active/active_context.md` means `.melted-peak/active/active_context.md`.
```

### Path Resolution

When Melted Peak references files like `active/active_context.md`, these resolve relative to the Melted Peak root:
- If MP is at `.melted-peak/`, then `active/active_context.md` = `.melted-peak/active/active_context.md`
- If MP is at project root, paths resolve directly

### Rule Priority

When project rules and Melted Peak rules conflict:
1. **Project-specific code rules** take priority for code changes (style, patterns, architecture)
2. **Melted Peak process rules** take priority for workflow (change plans, issue isolation, handoffs)
3. If genuinely ambiguous, follow the project rule and note the conflict in `memory/known_issues.md`

## Strategy: Melted Peak at Project Root

If the project doesn't have an existing CLAUDE.md, Melted Peak's CLAUDE.md becomes the project's CLAUDE.md.

Add a project-specific section at the bottom:

```markdown
---

## Project-Specific Rules

### Tech Stack
- [language, framework, etc.]

### Code Conventions
- [style rules, naming conventions, etc.]

### Testing
- [test framework, coverage requirements, etc.]

### Deployment
- [deployment process, environments, etc.]
```

## Keeping Both in Sync

When updating the project's CLAUDE.md:
- Do NOT modify the Melted Peak integration block
- Project-specific rules go in the project-specific section
- Melted Peak upgrades update files inside `.melted-peak/` only
- Log CLAUDE.md changes in `memory/recent_deltas.md`

## Upgrading Melted Peak

To upgrade MP in an existing project:
1. Back up current `.melted-peak/memory/` and `.melted-peak/active/`
2. Replace `.melted-peak/docs/`, `.melted-peak/frameworks/`, `.melted-peak/skills/`
3. Restore `memory/` and `active/` from backup
4. Verify `CLAUDE.md` integration block is still correct
5. Run `/boot` to verify everything works
