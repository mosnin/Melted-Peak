# Observation Taxonomy

Structured classification for memory entries in `memory/recent_deltas.md`, `memory/progress_log.md`, and `memory/change_log.md`.

## Observation Types

Every memory entry MUST include a type tag. Use exactly one:

| Type | Tag | Description | Example |
|------|-----|-------------|---------|
| Bug Fix | `[bugfix]` | Something was broken, now fixed | Fixed null pointer in auth flow |
| Feature | `[feature]` | New capability added | Added OAuth2 PKCE support |
| Refactor | `[refactor]` | Code restructured, behavior unchanged | Extracted validation into shared module |
| Change | `[change]` | Generic modification (docs, config, misc) | Updated deployment config for staging |
| Discovery | `[discovery]` | Learning about existing system | Found that rate limiter uses sliding window |
| Decision | `[decision]` | Architectural/design choice with rationale | Chose PostgreSQL over MongoDB for ACID guarantees |

## Concept Tags

Each entry SHOULD include 1-3 concept tags describing the knowledge type:

| Concept | Tag | Description |
|---------|-----|-------------|
| How It Works | `#how-it-works` | Understanding mechanisms |
| Why It Exists | `#why-it-exists` | Purpose or rationale |
| What Changed | `#what-changed` | Modifications made |
| Problem-Solution | `#problem-solution` | Issues and their fixes |
| Gotcha | `#gotcha` | Traps, edge cases, surprising behavior |
| Pattern | `#pattern` | Reusable approach |
| Trade-Off | `#trade-off` | Pros/cons of a decision |

## Entry Format

```
### YYYY-MM-DD HH:MM — [type] Title
Concepts: #tag1 #tag2
Files: path/to/file1, path/to/file2

Description of what happened, what was learned, and why it matters.
```

## Example Entries

```
### 2026-03-28 14:30 — [bugfix] Fixed race condition in session handoff
Concepts: #problem-solution #gotcha
Files: memory/session_handoff.md, docs/core/06_session_handoff_protocol.md

The handoff protocol could overwrite in-progress writes if two agents triggered simultaneously. Added file locking check before write. Root cause: no concurrency guard on shared state files.

### 2026-03-28 15:00 — [decision] Chose SQLite over plain files for metrics
Concepts: #trade-off #why-it-exists
Files: docs/decisions/adr-004-metrics-storage.md

Plain markdown metrics files don't scale past ~200 entries for search. SQLite with FTS5 would enable filtered queries. Decision: keep markdown for now (simpler), add SQLite when metrics exceed 500 entries.

### 2026-03-28 16:00 — [discovery] Context compiler loads unused knowledge packs
Concepts: #how-it-works #gotcha
Files: docs/core/02_context_compiler.md

The "bug-fix" profile loads debugging-patterns knowledge pack even when the bug is in CSS. Added note to tune profiles based on context_usage.md tracking.
```

## Usage

- `memory/recent_deltas.md` — all entries use this format
- `memory/progress_log.md` — use type tags for task entries
- `memory/change_log.md` — use type tags for system changes
- Retrospective skill reads these tags to analyze patterns
- Pattern journal uses concept tags to detect recurring themes
