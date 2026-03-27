# Security Audit -- Summary

Comprehensive security audit workflow that evaluates a project across twelve steps: dependency scanning, OWASP Top 10 checklist, secrets detection, authentication review, authorization review, input validation, API security, data protection, infrastructure hardening, severity classification, and Melted Peak integration.

## When to Use
- Before a major release or deployment
- When the user requests a security review
- After adding authentication, authorization, or data-handling code
- When integrating new third-party dependencies or APIs
- When a vulnerability is reported or suspected

## Key Steps
1. Scope the audit (full or targeted, identify tech stack)
2. Scan dependencies for known CVEs
3. Evaluate against OWASP Top 10 categories
4. Detect hardcoded secrets and exposed credentials
5. Review authentication (passwords, sessions, tokens, MFA)
6. Review authorization (RBAC, privilege escalation, data isolation)
7. Check input validation (sanitization, parameterized queries, output encoding)
8. Assess API security (rate limiting, CORS, headers, error responses)
9. Evaluate data protection (encryption, PII handling, retention)
10. Check infrastructure (HTTPS, cookies, server hardening)
11. Classify findings by severity (critical, high, medium, low, informational)
12. Report findings and integrate with Melted Peak (regression checklist, known issues)

## Depth Levels
- **Targeted**: Single subsystem or specific concern
- **Standard**: All sections, surface-level review
- **Deep**: All sections with full tracing, pre-release or post-incident

## Context Cost
Small -- workflow guide only.
