---
name: security-audit
description: Use when reviewing code for security vulnerabilities — before deploying, merging security-sensitive changes, or after adding auth code
user-invocable: false
---

# Security Audit

**Quick checklist:** No secrets in code | Input validation at boundaries | SQL/command injection prevention | Auth sessions expire | Authorization on every endpoint | No known CVEs in deps | Errors don't leak internals

See `skills/security-audit/source/SKILL.md` for full audit workflow.
