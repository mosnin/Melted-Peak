# Debugging -- Summary

Systematic four-phase debugging workflow: Characterize, Isolate, Fix, Harden. Prevents circular debugging by requiring every attempt to be logged before execution.

## When to Use
- Bug reports or unexpected behavior
- Test failures
- Regressions detected during change verification
- Context compiler selects `bug-fix` work type

## Key Steps
1. **Characterize**: Write issue, check known issues, check recent changes, reproduce
2. **Isolate**: Form hypothesis, narrow scope, trace data flow, verify root cause
3. **Fix**: Write change plan, log attempt, implement minimal fix, verify
4. **Harden**: Update regression checklist, close issue, update logs

## Critical Rules
- Never skip characterization (Phase 1)
- Always log attempts before trying them
- Three failures → STOP and re-analyze
- One bug at a time
- Minimal fix only -- no "while I'm here" changes

## Context Cost
Small -- the skill itself is a workflow guide, not reference material.
