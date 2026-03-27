# Validation Plan -- Filled Example

This shows what `active/validation_plan.md` looks like during a completed validation.

---

# Validation Plan

## Related Change Plan
Token refresh race condition fix -- increase buffer to 60s and add mutex lock on refresh

## Positive Tests

| Test | Expected Result | Actual Result | Pass? |
|------|----------------|---------------|-------|
| Login and wait 55 minutes | Token refreshes before expiry | Token refreshed at 54:00 mark | YES |
| Login and wait 65 minutes under load | Token still valid after refresh | Session maintained, new token issued | YES |
| Rapid page navigation during refresh window | No 401 errors | All requests succeeded (mutex prevented double-refresh) | YES |

## Negative Tests

| Test | Expected Result | Actual Result | Pass? |
|------|----------------|---------------|-------|
| Provide invalid refresh token | Returns 401, redirects to login | 401 returned, redirect to /login | YES |
| Revoke session server-side, then navigate | Returns 401, clears local session | 401 returned, local token cleared | YES |
| Send expired token with no refresh token | Returns 401, no infinite retry | 401, no retry loop (confirmed with network tab) | YES |

## Boundary Tests

| Test | Expected Result | Actual Result | Pass? |
|------|----------------|---------------|-------|
| Token with exactly 60s remaining | Refresh fires immediately | Refresh triggered, new token received | YES |
| Token with 61s remaining | No refresh yet | No refresh (buffer threshold not reached) | YES |
| Two tabs open simultaneously | Only one refresh request | Mutex prevented duplicate (verified server logs) | YES |

## Regression Checks

| Checklist Item | Verified? | Notes |
|---------------|-----------|-------|
| Social OAuth login flow | YES | Tested Google and GitHub -- not affected by refresh changes |
| Admin session handling | YES | Uses separate mechanism, no shared code |
| API key authentication | YES | Bypasses token refresh entirely |

## Integration Checks

| System | Check | Result |
|--------|-------|--------|
| Database sessions table | No orphaned sessions after refresh | PASS -- old sessions cleaned up |
| Redis token cache | Cache invalidated on refresh | PASS -- verified cache miss after refresh |
| Monitoring (Sentry) | No new auth-related errors | PASS -- zero auth errors in 30min test |

## Overall Result
PASS -- all 12 tests passed, all regression checks verified, all integration points confirmed.

## Notes
- The mutex approach adds ~2ms latency to the refresh request -- negligible
- Recommend monitoring the `auth.refresh.duration` metric for the first week post-deploy
- Added auth middleware to regression checklist for future changes
