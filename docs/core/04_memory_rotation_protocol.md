# Memory Rotation Protocol

Defines how memory files are kept at manageable sizes. Unbounded append-only files eventually become too large to read and waste context window.

---

## File Size Limits

| File | Max Size | Rotation Strategy |
|------|----------|-------------------|
| `memory/recent_deltas.md` | Last 3 sessions | Archive older entries to `memory/archive/deltas/` |
| `memory/progress_log.md` | Last 10 sessions | Archive older entries to `memory/archive/progress/` |
| `memory/change_log.md` | Last 20 entries | Archive older entries to `memory/archive/changes/` |
| `memory/known_issues.md` | Unlimited (resolved issues archived) | Move resolved issues to `memory/archive/resolved_issues.md` |
| `memory/session_handoff.md` | 1 entry (replaced each session) | Previous handoff archived to `memory/progress_log.md` |
| `memory/architecture_decisions.md` | Unlimited (rarely grows fast) | No rotation needed |

## When to Rotate

Check file sizes during the **session handoff protocol** (Step 0, before writing new content):

1. Read the target file
2. If it exceeds the limit above, move older entries to the archive
3. Write the new content

## Archive Structure

```
memory/archive/
├── deltas/
│   └── deltas_YYYY-MM.md      # Monthly archives
├── progress/
│   └── progress_YYYY-MM.md    # Monthly archives
├── changes/
│   └── changes_YYYY-MM.md     # Monthly archives
└── resolved_issues.md          # All resolved issues
```

## Rotation Procedure

### For recent_deltas.md
1. Count session markers (entries between `---` separators or date headers)
2. If more than 3 sessions of entries exist:
   - Move entries older than 3 sessions to `memory/archive/deltas/deltas_YYYY-MM.md`
   - Keep only the most recent 3 sessions in the main file

### For progress_log.md
1. Count date-sectioned entries
2. If more than 10 sessions of entries exist:
   - Move older entries to `memory/archive/progress/progress_YYYY-MM.md`
   - Keep only the most recent 10 sessions

### For change_log.md
1. Count entries
2. If more than 20 entries:
   - Move older entries to `memory/archive/changes/changes_YYYY-MM.md`
   - Keep only the most recent 20

### For known_issues.md
1. Find issues with status `resolved`
2. Move them to `memory/archive/resolved_issues.md`
3. Keep only `open` and `assigned` issues in the main file

## Accessing Archived Data

Archives are warm storage -- only read when investigating historical context:
- "What changed last month?" → `memory/archive/changes/`
- "Did we solve a similar issue before?" → `memory/archive/resolved_issues.md`
- "What was the project state 3 months ago?" → `memory/archive/progress/`

The context compiler should check archives when the current memory files don't have enough history.
