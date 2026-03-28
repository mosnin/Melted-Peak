---
name: debugging
description: Use when encountering any bug, test failure, unexpected behavior, or regression — before proposing fixes
user-invocable: false
---

# Debugging

**Core principle:** Find root cause before attempting fixes. Symptom fixes are failure.

**4 Phases:**
1. **Characterize** — write issue, check known_issues.md, check recent_deltas.md, reproduce
2. **Isolate** — hypothesis, narrow scope, trace data flow, verify root cause (WHY not just WHERE)
3. **Fix** — change plan, log attempt in active_issue.md, minimal fix, verify
4. **Harden** — update regression_checklist.md, close issue

**Three-strike rule:** 3 failed attempts → STOP, root cause analysis, present options to user.
**Analysis paralysis guard:** 5+ consecutive reads without a write = stop reading and act. Summarize what you know, form a hypothesis, test with smallest change.

See `skills/debugging/source/SKILL.md` for full workflow.
