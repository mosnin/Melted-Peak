# Error Handling Design -- Summary

Comprehensive guide for designing error handling across all application layers. Provides classification frameworks, standard response formats, retry and resilience patterns, and integration points with Melted Peak workflows.

## When to Use
- Designing error handling for a new service, API, or feature
- Reviewing or improving existing error handling
- Investigating failures caused by missing or inconsistent error handling
- Building resilience into distributed or user-facing systems
- After an incident to verify error handling gaps

## Key Sections
1. **Error Classification** -- Three-axis model: transient/permanent, user-visible/internal, expected/unexpected
2. **Error Response Design** -- Standard error shape, error code taxonomy, HTTP status mapping
3. **Retry Patterns** -- Exponential backoff with jitter, circuit breaker states, retry budgets, idempotency
4. **Graceful Degradation** -- Fallback behavior per dependency, partial results, feature flag kill switches
5. **Logging Strategy** -- Structured logging format, severity levels, correlation IDs, what to log and what never to log
6. **User Feedback** -- Message tiers (field, form, toast, page, modal), recovery actions
7. **UI Error Boundaries** -- Placement strategy (app, route, widget), fallback UI patterns, retry mechanisms
8. **Testing Error Paths** -- Fault injection, assertions checklist, chaos testing concepts
9. **Layer-Specific Patterns** -- Common errors and handling for database, API, auth, file system, and network layers
10. **Melted Peak Integration** -- Feeds regression checklist, known issues tracking, change plan requirements

## Context Cost
Small -- single reference document, no external dependencies.
