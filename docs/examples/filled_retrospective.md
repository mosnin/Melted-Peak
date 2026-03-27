# Retrospective -- Filled Example

This shows what a completed retrospective entry looks like in `memory/metrics/retrospectives.md`.

---

### 2026-03-20 -- Token refresh race condition

**Outcome**: resolved
**Attempts**: 3
**Sessions**: 2
**Scope drift**: minor (also fixed a related token logging issue)

**What worked**:
- Checking `memory/recent_deltas.md` immediately identified a recent change to the token buffer constant as the likely culprit
- The debugging skill's "characterize before fixing" phase prevented wasted effort on wrong hypotheses
- The regression checklist caught that the social OAuth flow shared a utility function with the refresh logic -- verified it wasn't affected

**What didn't**:
- Attempt 1 (increase buffer to 30s) masked the symptom but didn't fix the race condition
- Attempt 2 (add retry logic to refresh) introduced complexity without addressing root cause
- Should have traced the full token lifecycle before attempting any fix -- would have found the race condition immediately

**System improvements made**:
- Added `src/auth/middleware.ts` to `active/regression_checklist.md` as a sensitive area
- Updated the debugging skill's Phase 2 to emphasize "trace the full data lifecycle" before forming hypotheses
- Logged "auth token flow" pattern in `memory/metrics/pattern_journal.md` -- may become a knowledge pack if auth issues recur

**Open improvements** (deferred):
- Consider creating a `knowledge/auth-patterns/` knowledge pack if auth-related issues occur 2 more times
- The token refresh utility lacks unit tests -- logged in `memory/known_issues.md`
