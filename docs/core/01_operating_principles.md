# Operating Principles

These are the non-negotiable rules that govern Melted Peak system behavior. They are not guidelines -- they are invariants.

---

## Principle 1: Context Is King

Every bug, wasted effort, and circular problem-solving session traces back to lost context. The system exists to prevent this.

**Rules:**
- Never assume previous context is still accurate. Verify from files.
- Record every decision, change, and discovery in the appropriate file.
- When in doubt about what happened previously, read the memory files before proceeding.
- Context that isn't written down doesn't exist.

## Principle 2: One Issue at a Time

Multitasking on issues creates cross-contamination. Changes for Issue A break Issue B. Focus prevents cascading errors.

**Rules:**
- Only one `active/active_issue.md` may be active at any time.
- If a new issue is discovered during work, log it to `memory/known_issues.md` but do NOT switch to it.
- Switching issues requires explicit user authorization.
- See `docs/core/07_issue_isolation_protocol.md` for the full protocol.

## Principle 3: Plan Before Acting

Unplanned changes are the primary source of regressions. A change plan takes minutes. Debugging a regression takes hours.

**Rules:**
- Every non-trivial change requires a change plan in `active/change_plan.md`.
- Trivial changes (comments, typos, formatting) are exempt but must still be logged.
- The plan must list: files to change, nature of changes, expected outcome, rollback approach.
- See `docs/core/23_change_control_system.md` for the full protocol.

## Principle 4: Verify Before Declaring Done

"It should work" is not verification. Verification means demonstrating that it does work and that nothing else broke.

**Rules:**
- Every change plan has a corresponding validation plan.
- Validation includes both positive testing (does it work?) and regression checking (did anything break?).
- Update `active/regression_checklist.md` with any new sensitive areas discovered.
- See `docs/core/25_regression_prevention.md` for the full protocol.

## Principle 5: Leave a Trail

Every session ends. The next session must be able to pick up seamlessly.

**Rules:**
- ALWAYS run the session handoff protocol before ending.
- `memory/session_handoff.md` must contain: progress, blockers, decisions, and next steps.
- `memory/recent_deltas.md` must reflect all changes made during the session.
- See `docs/core/06_session_handoff_protocol.md` for the full protocol.

## Principle 6: Minimal Working Context

Loading everything wastes context window. Loading nothing wastes time rebuilding context. The context compiler finds the balance.

**Rules:**
- Read summaries first, full source only when needed.
- Use the context compiler to select relevant components -- don't guess.
- Respect the `context_cost` field in manifests when assembling context.
- See `docs/core/02_context_compiler.md` for the full protocol.

## Principle 7: Normalize Before Use

Raw, unstructured components create inconsistency. Every component must pass through normalization and the readiness gate.

**Rules:**
- New components go to `incoming/` first. Always.
- Normalization creates the required three files (source, manifest, summary).
- The readiness gate verifies completeness before promotion.
- Nothing in `incoming/` may be referenced in active work.
- See `docs/core/10_ingestion_and_normalization_rules.md` and `docs/core/11_readiness_gate.md`.

---

## Safety Rules

1. **Never delete memory files.** Archive or rotate them, but never delete.
2. **Never skip the change plan** for non-trivial changes, even under time pressure.
3. **Never work on code without first understanding the current active context.**
4. **Never end a session without a handoff.** If the session is cut short, write at minimum a one-paragraph handoff.
5. **Never modify the core protocol files** (`docs/core/`) without explicit user authorization.
