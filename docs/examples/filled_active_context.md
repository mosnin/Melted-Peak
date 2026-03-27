# Active Context -- Filled Example

This shows what `active/active_context.md` looks like during real work.

---

# Active Context

## Current Goal
Fix the authentication token refresh bug that causes users to be logged out after 1 hour.

## Work Type
bug-fix

## Scope

### In Scope
- Token refresh logic in `src/auth/middleware.ts`
- Token storage in `src/auth/session.ts`
- Related auth tests in `tests/auth/`

### Out of Scope
- OAuth social login flows (working correctly)
- Password reset flow (separate issue)
- Admin auth (uses different mechanism)

## Loaded Components

| Component | Reason | Used? |
|-----------|--------|-------|
| skills/debugging | Bug-fix work type | yes |
| docs/core/25_regression_prevention | Required for bug-fix | yes |
| docs/core/07_issue_isolation_protocol | Required for bug-fix | no (only one issue) |
| memory/recent_deltas.md | Check recent changes | yes |

## Confidence Map

| Assumption | Confidence | Verify How |
|------------|-----------|------------|
| Bug is in token refresh, not token creation | medium | Check creation flow independently |
| Only affects 1-hour sessions (not shorter) | high | Confirmed via logs |
| Fix won't affect social OAuth flow | high | Social OAuth uses different token type |

## Current State
Phase 2 (Isolate). Reproduced the bug -- tokens expire at exactly 3600s but refresh fires at 3590s, leaving a 10s window where the token is expired but not yet refreshed. The issue is a race condition between the expiry check and the refresh request.

## Next Action
Write a change plan for fixing the race condition by adding a 30s buffer to the expiry check.

## Open Questions
- Should we also extend the token lifetime from 1hr to 4hr? (Ask user)

## Blockers
None.

## Session Notes
Found that the previous developer set `TOKEN_BUFFER_MS = 10000` (10s) which is too tight. The refresh endpoint sometimes takes > 10s under load.
