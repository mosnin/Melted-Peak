# Skill: API Design

## Purpose
Comprehensive guide for designing, implementing, and maintaining HTTP APIs that are consistent, discoverable, and resilient. Covers REST conventions, error handling, versioning, security, and integration with Melted Peak workflows.

## Trigger
- Designing a new API or set of endpoints
- Adding endpoints to an existing API
- Reviewing API contracts for consistency
- Planning breaking changes to an existing API
- When the user asks for API design guidance

---

## 1. API Contract Design

### REST Resource Conventions
- **Resources are nouns, not verbs**: `/users`, `/orders`, `/invoices` -- never `/getUsers` or `/createOrder`
- **Use plural nouns** for collections: `/users` not `/user`
- **Nest for relationships** (max 2 levels): `/users/{id}/orders` -- never `/users/{id}/orders/{oid}/items/{iid}/tags`
- **Use kebab-case** for multi-word resources: `/line-items`, `/payment-methods`
- **Resource IDs in the path**: `/users/42`, `/orders/abc-123`

### URL Structure
```
https://api.example.com/v1/users/{userId}/orders?status=active&sort=-createdAt&page=2&limit=25
\_____/ \_______________/ \/ \____/ \________/ \______/ \_______________________________________________/
scheme       host        ver resource  sub-resource        query parameters
```

### Naming Rules
- Paths are lowercase with hyphens
- Query parameters are camelCase
- Request/response body fields are camelCase
- Be consistent across the entire API surface -- pick conventions once and enforce them everywhere

---

## 2. HTTP Methods and Status Codes

### Methods

| Method | Purpose | Idempotent | Safe | Request Body |
|--------|---------|------------|------|--------------|
| GET | Retrieve resource(s) | Yes | Yes | No |
| POST | Create a resource or trigger an action | No | No | Yes |
| PUT | Full replacement of a resource | Yes | No | Yes |
| PATCH | Partial update of a resource | No* | No | Yes |
| DELETE | Remove a resource | Yes | No | Optional |
| HEAD | Same as GET but no body (check existence) | Yes | Yes | No |
| OPTIONS | Discover allowed methods / CORS preflight | Yes | Yes | No |

*PATCH can be made idempotent with JSON Merge Patch (RFC 7396) but is not required to be.

### When to Use Each
- **GET**: Always for reads. Never use POST for reads unless the query is too complex for URL length limits.
- **POST**: Creating new resources, triggering non-idempotent actions (e.g., sending a notification), batch operations.
- **PUT**: Only when the client sends the complete resource representation. If partial updates are needed, use PATCH.
- **PATCH**: Partial field updates. Prefer JSON Merge Patch (`application/merge-patch+json`) for simplicity.
- **DELETE**: Removing a resource. Return 204 on success. Make it idempotent -- deleting an already-deleted resource should return 204 or 404, not an error.

### Status Codes

#### Success (2xx)
| Code | When to Use |
|------|-------------|
| 200 OK | Successful GET, PUT, PATCH, or action POST |
| 201 Created | Successful POST that creates a resource (include `Location` header) |
| 202 Accepted | Request accepted for async processing |
| 204 No Content | Successful DELETE or PUT/PATCH when no body is returned |

#### Client Error (4xx)
| Code | When to Use |
|------|-------------|
| 400 Bad Request | Malformed syntax, invalid field values, validation failures |
| 401 Unauthorized | Missing or invalid authentication credentials |
| 403 Forbidden | Authenticated but not authorized for this action |
| 404 Not Found | Resource does not exist |
| 405 Method Not Allowed | HTTP method not supported on this endpoint |
| 409 Conflict | State conflict (e.g., duplicate resource, version mismatch) |
| 410 Gone | Resource was deleted and will not return |
| 415 Unsupported Media Type | Content-Type not accepted |
| 422 Unprocessable Entity | Syntactically valid but semantically wrong (validation errors) |
| 429 Too Many Requests | Rate limit exceeded (include `Retry-After` header) |

#### Server Error (5xx)
| Code | When to Use |
|------|-------------|
| 500 Internal Server Error | Unexpected server failure |
| 502 Bad Gateway | Upstream service failure |
| 503 Service Unavailable | Planned downtime or overload (include `Retry-After`) |
| 504 Gateway Timeout | Upstream service timeout |

**Rule of thumb**: Use the most specific code that applies. Avoid returning 200 with an error in the body.

---

## 3. Request/Response Design

### Standard Response Envelope

For collections:
```json
{
  "data": [...],
  "pagination": {
    "page": 2,
    "limit": 25,
    "totalItems": 142,
    "totalPages": 6
  }
}
```

For single resources:
```json
{
  "data": { ... }
}
```

The `data` wrapper is optional for simple APIs but valuable for consistency and extensibility (allows adding `meta`, `warnings`, etc. later).

### Pagination
- **Offset-based** (simple, good for most cases): `?page=2&limit=25`
- **Cursor-based** (better for large/real-time datasets): `?cursor=eyJpZCI6MTAwfQ&limit=25`
- Always return pagination metadata in the response
- Set a maximum `limit` (e.g., 100) and a sensible default (e.g., 25)
- Include `next` and `prev` links when possible (HATEOAS-lite)

### Filtering
- Simple filters as query params: `?status=active&role=admin`
- Range filters: `?createdAfter=2026-01-01&createdBefore=2026-03-01`
- For complex filters, consider a filter query language or POST-based search endpoint
- Document all supported filter fields

### Sorting
- Use `sort` param with field names: `?sort=createdAt` (ascending)
- Prefix with `-` for descending: `?sort=-createdAt`
- Multiple sort fields: `?sort=-priority,createdAt`

### Field Selection (Sparse Fieldsets)
- Allow clients to request only needed fields: `?fields=id,name,email`
- Reduces payload size and improves performance
- Always return `id` regardless of field selection

### Timestamps
- Use ISO 8601 format: `2026-03-27T14:30:00Z`
- Always use UTC
- Use `createdAt` and `updatedAt` consistently

---

## 4. Versioning Strategy

### Approaches

| Approach | Example | Pros | Cons |
|----------|---------|------|------|
| URL path | `/v1/users` | Simple, explicit, cacheable | URL changes on version bump |
| Header | `Accept: application/vnd.api+json;version=1` | Clean URLs | Harder to test, less discoverable |
| Query param | `?version=1` | Easy to use | Pollutes query string |

**Recommendation**: Use URL path versioning (`/v1/`, `/v2/`). It is the most discoverable, easiest to route, and simplest to document.

### Backwards Compatibility Rules
These changes are **backwards compatible** (safe within a version):
- Adding a new optional field to a response
- Adding a new endpoint
- Adding a new optional query parameter
- Adding a new optional request body field

These changes are **breaking** (require a new version):
- Removing or renaming a field
- Changing a field's type
- Making an optional field required
- Changing URL structure
- Changing authentication scheme
- Changing error response format

### Version Lifecycle
1. Announce deprecation with a timeline (minimum 6 months for external APIs)
2. Add `Deprecation` and `Sunset` headers to responses from deprecated versions
3. Monitor usage of deprecated versions
4. Remove only after traffic drops to zero or sunset date passes

---

## 5. Error Handling

### Standard Error Format
```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "The request contains invalid fields.",
    "details": [
      {
        "field": "email",
        "code": "INVALID_FORMAT",
        "message": "Must be a valid email address."
      },
      {
        "field": "age",
        "code": "OUT_OF_RANGE",
        "message": "Must be between 0 and 150."
      }
    ],
    "requestId": "req_abc123",
    "timestamp": "2026-03-27T14:30:00Z"
  }
}
```

### Error Code Design
- Use UPPER_SNAKE_CASE string codes, not numeric codes
- Make codes stable and documented -- clients will switch on them
- Group by domain: `AUTH_TOKEN_EXPIRED`, `PAYMENT_DECLINED`, `RATE_LIMIT_EXCEEDED`
- Include `requestId` for support and debugging correlation

### Error Message Guidelines
- `message` is for developers -- be specific and actionable
- Never expose stack traces, internal paths, or database details in production
- For 500 errors, return a generic message and log the full error server-side
- Validation errors should list all failing fields, not just the first one

---

## 6. Authentication and Authorization

### Authentication Patterns

| Pattern | Use Case |
|---------|----------|
| API Keys | Server-to-server, low-sensitivity, simple integrations |
| OAuth 2.0 + JWT | User-facing applications, delegated access |
| Bearer Tokens | Stateless auth with short-lived tokens |
| mTLS | High-security service-to-service communication |

### Best Practices
- Use `Authorization: Bearer <token>` header -- never pass tokens in URLs
- Tokens should be short-lived (15-60 minutes for access tokens)
- Use refresh tokens for long-lived sessions
- Scope tokens to minimum required permissions
- Return 401 for missing/invalid credentials, 403 for insufficient permissions
- Include a `WWW-Authenticate` header with 401 responses

### Authorization Patterns
- **Role-based (RBAC)**: Assign roles with predefined permission sets
- **Attribute-based (ABAC)**: Evaluate policies against request attributes
- **Resource-based**: Check ownership or explicit grants per resource
- Authorize at the endpoint level, not just the route level (check resource ownership)

---

## 7. Rate Limiting and Throttling

### Headers
Include these in every response:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 47
X-RateLimit-Reset: 1679940000
```

### Strategies
- **Fixed window**: Simple, but allows bursts at window boundaries
- **Sliding window**: Smoother distribution, slightly more complex
- **Token bucket**: Best for variable-rate workloads

### Implementation Guidelines
- Return 429 with `Retry-After` header when limit is exceeded
- Rate limit by API key, user ID, or IP -- never solely by IP for authenticated APIs
- Set different limits for different endpoints (read vs. write, search vs. CRUD)
- Document rate limits in API documentation
- Consider a higher tier or exemption process for legitimate high-volume users

---

## 8. Documentation

### OpenAPI / Swagger
- Maintain an OpenAPI 3.x specification as the source of truth
- Include for every endpoint:
  - Summary and description
  - All parameters with types, constraints, and examples
  - All response codes with schema and examples
  - Authentication requirements
- Generate docs from the spec (Swagger UI, Redoc, etc.)
- Version the spec file alongside the code

### Documentation Checklist
- [ ] Every endpoint has a description and at least one example
- [ ] Every request/response field has a type and description
- [ ] Error codes are listed with explanations
- [ ] Authentication flow is documented with examples
- [ ] Rate limits are documented
- [ ] Pagination approach is explained
- [ ] Changelog exists for version history
- [ ] Quick-start guide with curl examples

---

## 9. Testing API Contracts

### Contract Tests
- Validate that responses match the OpenAPI schema
- Test every documented status code path (not just 200)
- Verify error response format matches the standard
- Test pagination boundaries (first page, last page, empty page, beyond range)
- Test with invalid input to verify error handling

### Integration Tests
- Test the full request lifecycle: auth, request, response, side effects
- Test idempotency of PUT and DELETE
- Test concurrent requests for race conditions
- Test rate limiting behavior
- Test versioning (requests to deprecated versions still work during sunset period)

### Checklist for New Endpoints
- [ ] Happy path returns expected status code and body
- [ ] Missing required fields return 400/422 with field-level errors
- [ ] Invalid field types return 400
- [ ] Unauthenticated requests return 401
- [ ] Unauthorized requests return 403
- [ ] Non-existent resources return 404
- [ ] Response matches OpenAPI schema
- [ ] Pagination works correctly (if applicable)
- [ ] Rate limiting is applied

---

## 10. Integration with Melted Peak

### Change Plan for API Changes
When adding or modifying API endpoints, the change plan (`active/change_plan.md`) must include:
- Endpoint(s) being added or changed
- Request/response schema changes
- Whether the change is backwards compatible
- If breaking: migration plan and version bump strategy
- Affected clients or consumers
- Rollback approach (can the old schema be restored safely?)

### Regression Checklist for Endpoints
Add these entries to `active/regression_checklist.md` for every API change:
- Existing clients can still call the endpoint with their current request format
- Error responses still match the standard error format
- Authentication and authorization rules are unchanged (or intentionally changed)
- Pagination behavior is unchanged for existing query patterns
- Rate limits are unchanged (or intentionally changed)
- OpenAPI spec is updated to reflect the change

### Workflow
1. Write the change plan with API-specific fields listed above
2. Implement the changes
3. Run contract tests against the OpenAPI spec
4. Run the code review skill on the changes
5. Update the regression checklist with new sensitive areas
6. Update the OpenAPI spec and changelog

---

## Anti-Patterns

- **Overloading GET with side effects** -- GET must be safe and idempotent
- **Using 200 for everything** -- status codes exist for a reason; use them
- **Nested URLs deeper than 2 levels** -- flatten with query filters instead
- **Versioning individual endpoints** -- version the whole API surface together
- **Returning different error formats from different endpoints** -- standardize once
- **Exposing database IDs directly** -- use UUIDs or opaque identifiers
- **Designing the API around the database schema** -- design around client use cases
- **Ignoring backwards compatibility** -- every field removal is a breaking change
- **Building without a spec** -- write the OpenAPI spec before the implementation
