# API Design -- Summary

Comprehensive guide for designing consistent, well-documented HTTP APIs. Covers REST conventions, HTTP semantics, error handling, versioning, authentication, rate limiting, and contract testing.

## When to Use
- Designing a new API or adding endpoints to an existing one
- Reviewing an API for consistency and best practices
- Planning breaking changes or version bumps
- Setting up API documentation and contract tests

## Key Topics
1. **Resource naming and URL structure** -- plural nouns, max 2 levels of nesting, kebab-case paths
2. **HTTP methods and status codes** -- correct method for each operation, specific status codes over generic ones
3. **Request/response patterns** -- pagination (offset and cursor), filtering, sorting, field selection
4. **Versioning** -- URL path versioning recommended, backwards compatibility rules, deprecation lifecycle
5. **Error handling** -- standard error envelope with code, message, details, and requestId
6. **Auth** -- Bearer tokens, OAuth 2.0, scoping, 401 vs 403
7. **Rate limiting** -- standard headers, 429 responses, per-key limits
8. **Documentation** -- OpenAPI 3.x as source of truth, examples for every endpoint
9. **Testing** -- contract tests against the spec, integration test checklist for new endpoints
10. **Melted Peak integration** -- API-specific fields in change plans and regression checklists

## Context Cost
Small -- reference guide only, no external dependencies.
