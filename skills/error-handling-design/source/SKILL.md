# Skill: Error Handling Design

## Purpose
Comprehensive guide for designing error handling across all layers of an application. Covers classification, response formats, retry strategies, degradation patterns, logging, user feedback, UI error boundaries, testing error paths, and layer-specific patterns.

## Trigger
- Designing a new service, API, or feature that needs error handling strategy
- Reviewing or improving existing error handling
- Debugging failures caused by missing or inconsistent error handling
- Building resilience into distributed systems or user-facing flows

---

## 1. Error Classification

Before handling errors, classify them. Every error fits into three independent axes:

### Axis 1: Transient vs. Permanent
| Type | Definition | Action |
|------|-----------|--------|
| **Transient** | Temporary condition that may resolve on its own (network timeout, rate limit, lock contention) | Retry with backoff |
| **Permanent** | Condition that will not self-resolve (invalid input, missing resource, permission denied) | Fail fast, report clearly |

### Axis 2: User-Visible vs. Internal
| Type | Definition | Action |
|------|-----------|--------|
| **User-visible** | The user needs to know something went wrong (form validation, payment failure) | Show a clear, actionable message |
| **Internal** | Infrastructure/operational concern (database failover, cache miss) | Log for operators, hide from users |

### Axis 3: Expected vs. Unexpected
| Type | Definition | Action |
|------|-----------|--------|
| **Expected** | Part of normal control flow (item not found, auth expired) | Handle with specific logic, no alerts |
| **Unexpected** | Should never happen in correct operation (null reference, corrupt state) | Alert, log full context, trigger investigation |

### Classification Checklist
When encountering a new error scenario, answer:
1. Will this resolve on its own? (transient/permanent)
2. Does the user need to see this? (user-visible/internal)
3. Is this a normal case or a defect? (expected/unexpected)

The intersection determines the handling strategy. Example: a rate-limit response is transient + internal + expected -- retry silently with backoff, no user notification needed.

---

## 2. Error Response Design

### Standard Error Format
Define a single error response shape used across all APIs:

```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "The requested item does not exist.",
    "details": [],
    "request_id": "abc-123",
    "timestamp": "2026-03-27T10:00:00Z"
  }
}
```

### Design Principles
- **Machine-readable code**: Stable string constant (e.g., `VALIDATION_FAILED`). Clients switch on this.
- **Human-readable message**: Can change without breaking clients. Never embed codes clients parse.
- **Details array**: For field-level validation errors or multi-error responses.
- **Request ID**: Always include. Links client-visible error to server logs.

### Error Code Taxonomy
Organize codes by domain:
- `AUTH_*` -- authentication/authorization (AUTH_EXPIRED, AUTH_FORBIDDEN)
- `VALIDATION_*` -- input validation (VALIDATION_REQUIRED, VALIDATION_FORMAT)
- `RESOURCE_*` -- resource operations (RESOURCE_NOT_FOUND, RESOURCE_CONFLICT)
- `RATE_*` -- throttling (RATE_LIMIT_EXCEEDED)
- `INTERNAL_*` -- server-side (INTERNAL_ERROR, INTERNAL_TIMEOUT)

### HTTP Status Mapping
Map error codes to HTTP statuses consistently:

| Status | When to Use |
|--------|------------|
| 400 | Malformed request, validation failure |
| 401 | Missing or invalid authentication |
| 403 | Authenticated but not authorized |
| 404 | Resource does not exist |
| 409 | Conflict (duplicate, stale update) |
| 422 | Semantically invalid (well-formed but wrong) |
| 429 | Rate limit exceeded |
| 500 | Unhandled server error |
| 502 | Upstream service failure |
| 503 | Service unavailable (maintenance, overloaded) |
| 504 | Upstream timeout |

### Rules
- Never return 200 with an error body. Use proper status codes.
- Never leak stack traces, internal paths, or database details in production error responses.
- Always return the standard error shape, even for framework-generated errors (404, 405, etc.).

---

## 3. Retry Patterns

### When to Retry
Only retry **transient** errors. Never retry permanent failures (400, 401, 403, 404, 422).

Retryable signals:
- HTTP 429 (respect Retry-After header)
- HTTP 500, 502, 503, 504
- Connection reset, timeout, DNS resolution failure
- Database lock contention, deadlock

### Exponential Backoff with Jitter
Base algorithm:
```
delay = min(base_delay * 2^attempt + random_jitter, max_delay)
```

Recommended defaults:
- Base delay: 100-500ms
- Max delay: 30-60 seconds
- Max retries: 3-5
- Jitter: random value between 0 and base_delay

**Why jitter matters**: Without jitter, retries from multiple clients synchronize ("thundering herd"), amplifying the original problem.

### Circuit Breaker Pattern
Prevents cascading failures by stopping requests to a failing dependency:

**States:**
1. **Closed** (normal): Requests flow through. Track failure rate.
2. **Open** (tripped): All requests fail immediately without calling the dependency. Return fallback or error.
3. **Half-Open** (probing): After a cooldown period, allow a single request through. If it succeeds, return to Closed. If it fails, return to Open.

**Configuration:**
- Failure threshold: e.g., 5 failures in 60 seconds
- Cooldown period: e.g., 30 seconds
- Success threshold for recovery: e.g., 3 consecutive successes in half-open

### Retry Budget
Set a global retry budget per service: no more than N% of total requests should be retries (e.g., 10%). This prevents retry storms from overwhelming a recovering service.

### Idempotency Requirement
Retries are only safe for idempotent operations. For non-idempotent operations (creating a resource, processing a payment), use an idempotency key to ensure the operation is applied at most once.

---

## 4. Graceful Degradation

### Fallback Behavior
When a dependency fails, degrade rather than crash:

| Dependency | Fallback |
|-----------|----------|
| Recommendation engine | Show popular/recent items |
| Search service | Show category browse |
| User avatar service | Show default avatar |
| Analytics/telemetry | Drop data silently, continue |
| Payment processor | Queue for retry, notify user of delay |
| Cache | Fall through to database (accept higher latency) |

### Partial Results
When a page aggregates data from multiple sources:
- Return what you have, mark missing sections as unavailable
- Include metadata indicating which parts are degraded
- Set a deadline for aggregate calls; return partial after timeout

### Feature Flags for Degradation
Use feature flags to:
- Disable non-critical features under load
- Route around broken dependencies
- Gradually restore features after an incident

Design features with a "kill switch" from the start. Every non-critical feature should be independently disableable.

### Graceful Degradation Checklist
For each external dependency, document:
1. What happens if it is down for 5 seconds? 5 minutes? 5 hours?
2. What is the fallback behavior?
3. Is there a feature flag to disable the integration?
4. What does the user see during degradation?

---

## 5. Logging Strategy

### What to Log

**Always log:**
- Request ID / correlation ID
- Timestamp (ISO 8601, UTC)
- Error code and message
- Stack trace (for unexpected errors)
- User ID or session ID (if available, never log credentials)
- Operation being performed
- Input parameters (sanitized -- never log passwords, tokens, PII)

**Never log:**
- Passwords, API keys, tokens, secrets
- Full credit card numbers, SSNs, or other PII
- Request/response bodies containing user-submitted sensitive data

### Structured Logging
Use structured (JSON) log entries, not free-text strings:
```json
{
  "level": "error",
  "timestamp": "2026-03-27T10:00:00Z",
  "request_id": "abc-123",
  "error_code": "RESOURCE_NOT_FOUND",
  "message": "Item lookup failed",
  "user_id": "user-456",
  "operation": "getItem",
  "item_id": "item-789",
  "duration_ms": 45
}
```

Structured logs are searchable, filterable, and aggregatable. Free-text logs are not.

### Severity Levels

| Level | When | Alerting |
|-------|------|----------|
| **DEBUG** | Detailed diagnostic info for development | Never alert |
| **INFO** | Normal operations (request served, job completed) | Never alert |
| **WARN** | Degraded but functioning (retry succeeded, fallback used, approaching limit) | Monitor dashboards |
| **ERROR** | Operation failed, user impacted, needs attention | Alert on-call if rate exceeds threshold |
| **FATAL** | Process cannot continue, service is down | Immediate alert |

### Correlation IDs
- Generate a unique ID at the entry point of every request
- Pass it through every service call, log entry, and error response
- The user sees the request ID in the error response and can quote it to support
- Operators search logs by this ID to trace the full request lifecycle

---

## 6. User Feedback

### Error Message Principles
- **Be specific**: "Your email address is not valid" not "Invalid input"
- **Be actionable**: Tell the user what to do. "Try again in a few minutes" or "Check your email format"
- **Be honest**: Do not say "something went wrong" when you know exactly what happened
- **Be blame-free**: Never imply the user is at fault for system errors
- **Be brief**: One or two sentences maximum

### Message Tiers
| Tier | Example | When |
|------|---------|------|
| Field-level | "Email is required" shown next to the email field | Validation errors |
| Form-level | "Please fix the errors below" at the top of the form | Multiple field errors |
| Toast/banner | "Your changes have been saved" or "Unable to save, retrying..." | Async operations |
| Full-page | "This page is temporarily unavailable" | Service-level failure |
| Modal/blocking | "Your session has expired. Please log in again." | Requires user action to proceed |

### Recovery Actions
Always offer a next step when possible:
- Retry button for transient errors
- Link to support for persistent errors
- "Go back" or "Return home" for dead ends
- Auto-retry with a progress indicator for background operations

---

## 7. Error Boundaries in UI

### React Error Boundaries
Place error boundaries at strategic levels:

1. **App-level boundary**: Catches anything that slips through. Shows a "something went wrong, reload" page.
2. **Route/page-level boundary**: Isolates failures to a single page. Other pages remain functional.
3. **Widget/component-level boundary**: A failing widget does not take down the page. Shows a placeholder with a retry option.

### Boundary Design Principles
- Boundaries catch rendering errors, not event handler errors (those need try/catch)
- Log the error and component stack to your error reporting service
- Show a fallback UI that matches the surrounding design (not a raw stack trace)
- Include a retry mechanism: either a "Try Again" button that resets the boundary state, or an automatic retry with exponential backoff
- Report which boundary caught the error so you know where in the component tree the failure occurred

### Fallback UI Patterns
- **Skeleton with error state**: Show the layout structure with an error message in place of content
- **Retry card**: Compact card saying "Failed to load [section]. [Retry]"
- **Reduced functionality**: Hide the broken feature, show the rest of the page

---

## 8. Testing Error Paths

### Simulating Failures
- **Unit tests**: Mock dependencies to return errors. Test every catch block.
- **Integration tests**: Use fault-injection middleware to return error status codes.
- **Contract tests**: Verify your error responses match the standard error format.
- **Manual testing**: Use tools or feature flags to trigger error states and verify the user experience.

### What to Assert
- Correct HTTP status code is returned
- Error response matches the standard shape
- Sensitive data is not leaked in error responses
- Retry logic fires the expected number of times with correct delays
- Circuit breaker opens after the configured failure threshold
- Fallback behavior activates when the dependency is unavailable
- Error boundaries render the correct fallback UI
- Logs contain the expected structured fields
- Correlation ID appears in both the response and the logs

### Chaos Testing Concepts
For production-grade systems, consider:
- Randomly terminating instances to verify restart/failover
- Injecting latency to verify timeout handling
- Blocking network traffic to specific dependencies to verify circuit breakers
- Filling disk or exhausting memory to verify resource-limit handling

Start with controlled fault injection in staging before running chaos experiments in production.

---

## 9. Common Error Patterns by Layer

### Database Layer
| Error | Classification | Handling |
|-------|---------------|----------|
| Connection refused | Transient | Retry with backoff, circuit breaker |
| Deadlock | Transient | Retry (most databases auto-rollback) |
| Constraint violation (unique, FK) | Permanent, expected | Return 409 Conflict with explanation |
| Query timeout | Transient | Retry once, then fail; investigate slow query |
| Data corruption | Permanent, unexpected | Alert immediately, do not retry |

### API / HTTP Layer
| Error | Classification | Handling |
|-------|---------------|----------|
| 429 Rate limited | Transient | Backoff, respect Retry-After header |
| 500 Internal error | Transient (usually) | Retry with backoff |
| 502/503/504 | Transient | Retry with backoff, circuit breaker |
| 400 Bad request | Permanent | Fix the request, do not retry |
| 401 Unauthorized | Permanent (or refresh) | Refresh token once, then fail to login |
| Network timeout | Transient | Retry with backoff |

### Authentication Layer
| Error | Classification | Handling |
|-------|---------------|----------|
| Token expired | Expected | Refresh automatically, retry original request |
| Invalid credentials | Permanent, user-visible | Show clear message, do not reveal which field is wrong |
| Account locked | Permanent, user-visible | Show lockout message with unlock instructions |
| MFA failure | Expected, user-visible | Allow retry, enforce attempt limit |

### File System Layer
| Error | Classification | Handling |
|-------|---------------|----------|
| File not found | Permanent (usually) | Return 404 or create if appropriate |
| Permission denied | Permanent | Log, return 403 |
| Disk full | Transient (after cleanup) | Alert, fail, trigger cleanup |
| File locked | Transient | Retry briefly, then fail |

### Network Layer
| Error | Classification | Handling |
|-------|---------------|----------|
| DNS resolution failure | Transient | Retry with backoff |
| Connection reset | Transient | Retry with backoff |
| TLS handshake failure | Permanent (usually) | Do not retry, investigate certificate |
| Connection pool exhaustion | Transient | Queue or fail fast, alert on threshold |

---

## 10. Integration with Melted Peak

### Error State Taxonomy Feeds Regression Checklist
When you design or encounter error handling for a component:
1. Identify the error-sensitive areas (database connections, external APIs, auth flows)
2. Add these areas to `active/regression_checklist.md` so future changes are verified against them
3. Tag entries with the error class (e.g., "transient/network", "permanent/validation")

### Known Issues for Recurring Errors
When an error recurs across sessions or incidents:
1. Log it in `memory/known_issues.md` with the error code, frequency, and impact
2. Link to the relevant error pattern from this skill
3. Prioritize based on user impact and frequency

### Change Plans and Error Handling
When writing a `active/change_plan.md` that involves error handling changes:
- List every error path being added or modified
- Specify the classification for each new error
- Define the expected user experience for each error state
- Include error-path tests in the validation plan

### Session Handoff
When handing off a session that involved error handling work:
- Note any new error codes introduced
- Note any circuit breakers or retry policies configured
- Flag any error paths that are implemented but not yet tested

---

## Anti-Patterns

- Swallowing errors silently (catch with no logging or re-throw)
- Exposing stack traces to users in production
- Generic "Something went wrong" for every error type
- Retrying permanent errors (4xx status codes)
- No timeout on external calls (waiting forever)
- Logging sensitive data in error messages (passwords, tokens, PII)
- Catching broad exception types without re-throwing unexpected ones
- Using error codes that clients parse from human-readable messages
- Missing correlation IDs in distributed systems
- No circuit breaker on dependencies with known instability
