# Skill: Modaf Doctor

## Purpose
Diagnostic and repair system for Modaf framework and project docs. Finds broken cross-references, missing files, stale manifest entries, and malformed tables. Never rewrites content, deletes files, or modifies specifications.

## Trigger
- User says "run doctor mode", "run Modaf doctor", "check framework health", "diagnose the docs", or "fix broken docs"

## Workflow

1. Read `peaks/modaf-saas/knowledge/saas-internal/source/internal/25_doctor_mode.md`
2. Follow the diagnostic and repair protocol defined there
3. Report findings to the user

## Safety
- Doctor mode is a structural linter
- It never rewrites content or deletes files
- It only finds and reports structural issues
- Repairs are limited to fixing broken references and adding missing entries
