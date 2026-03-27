# Skill: Error Handling Design

## Purpose
Proactive error handling design -- classify errors, define response strategies, implement resilience patterns, and ensure good user feedback. Design error paths before they happen, not after.

## Trigger
- Designing a new feature with failure modes
- Reviewing error handling in existing code
- After a production incident reveals poor error handling
- When building API endpoints or user-facing flows

## Workflow

### Step 1: Classify Errors

| Dimension | Categories |
|-----------|-----------|
| **Visibility** | User-visible (show message) vs Internal (log only) |
| **Duration** | Transient (retry may work) vs Permanent (won't resolve) |
| **Expectation** | Expected (validation, 404) vs Unexpected (crash, timeout) |
| **Origin** | Client (bad input) vs Server (bug) vs External (third-party down) |

### Step 2: Define Error Response Format

Standardize across the application:
```json
{
  "error": {
    "code": "AUTH_TOKEN_EXPIRED",
    "message": "Your session has expired. Please log in again.",
    "status": 401,
    "details": {}
  }
}
```

Rules:
- `code`: Machine-readable, SCREAMING_SNAKE_CASE
- `message`: Human-readable, actionable, no stack traces
- `status`: HTTP status code (APIs) or error severity (internal)
- `details`: Optional structured data for debugging

### Step 3: Map HTTP Status Codes

| Status | When to Use |
|--------|------------|
| 400 | Client sent invalid data |
| 401 | Not authenticated |
| 403 | Authenticated but not authorized |
| 404 | Resource not found |
| 409 | Conflict (duplicate, stale state) |
| 422 | Validation failed (semantic error) |
| 429 | Rate limited |
| 500 | Unexpected server error |
| 502/503 | External service unavailable |

### Step 4: Implement Resilience Patterns

#### Retry (for transient errors)
```
Retry with exponential backoff:
  attempt 1: immediate
  attempt 2: wait 1s
  attempt 3: wait 2s
  attempt 4: wait 4s
  max: 3-5 retries

Add jitter (random 0-500ms) to prevent thundering herd.
Only retry transient errors (5xx, timeouts, network). Never retry 4xx.
```

#### Circuit Breaker (for failing external services)
```
States: closed → open → half-open

closed: requests pass through normally
open: requests fail immediately (don't hit the failing service)
half-open: allow one test request through

Trip at: 5 failures in 30 seconds
Reset after: 60 seconds in open state
```

#### Graceful Degradation
- If search is down → show recent items instead
- If analytics service is down → queue events, process later
- If image CDN is down → show placeholder, not broken image
- If payment fails → save cart, offer to retry later

### Step 5: Design User Feedback

| Error Type | User Feedback |
|-----------|--------------|
| Validation | Inline field errors, specific message |
| Auth expired | Redirect to login with return URL |
| Permission denied | Clear message, no retry option |
| Server error | "Something went wrong" + retry button |
| Network error | "Check your connection" + auto-retry |
| Rate limited | "Too many requests, try again in Xs" |
| Maintenance | Friendly page with estimated return time |

### Step 6: Implement Logging

```
What to log for every error:
- Timestamp
- Error code and message
- Request context (URL, method, user ID)
- Stack trace (for unexpected errors only)
- Correlation ID (for tracing across services)

Severity levels:
- ERROR: Unexpected failures requiring attention
- WARN: Expected failures worth monitoring (rate limits, validation)
- INFO: Normal operations (successful auth, feature usage)
- DEBUG: Development details (query times, cache hits)
```

### Step 7: Test Error Paths

For each error scenario:
1. Can you trigger it reliably in tests?
2. Does the right error code/message return?
3. Does the user see appropriate feedback?
4. Does the error log correctly?
5. Does retry/circuit breaker behave correctly?

## Integration with Melted Peak

- **Regression checklist**: Add error-handling-sensitive areas
- **Known issues**: Log recurring error patterns
- **Pattern journal**: If error handling follows a repeated pattern, log for potential skill creation
- **Architecture decisions**: Log error strategy choices as ADRs

## Anti-Patterns

- Swallowing errors silently (catch with no logging)
- Exposing stack traces to users
- Generic "Something went wrong" for every error
- Retrying permanent errors (4xx)
- No timeout on external calls
- Logging sensitive data in error messages (passwords, tokens)
