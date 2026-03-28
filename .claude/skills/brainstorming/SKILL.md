---
name: brainstorming
description: Use when a user describes something they want to build, before any code is written — ask questions to understand the real problem, explore alternatives, and produce a validated spec
user-invocable: false
---

# Brainstorming

Socratic design refinement before writing any code.

**Never start coding during brainstorming. Output is a written spec.**

**4 Phases:**

1. **Understand the real problem** — ask 2-3 questions at a time:
   - What problem does this solve?
   - Who experiences it and when?
   - What does success look like?
   - What are the constraints?

2. **Explore alternatives** — 2-3 different approaches with tradeoffs

3. **Present design in sections** — one section at a time, wait for feedback:
   - Overview → Scope → Interface/contract → Key decisions → Open questions

4. **Document** — write spec to `docs/specs/[YYYY-MM-DD]-[name].md`, then suggest `/plan`

**Red Flags:**
- Jumping to "here's how I'd implement this" without asking questions
- Presenting a full 500-word design without checkpoints
- Treating first stated requirement as the real requirement

See `skills/brainstorming/source/SKILL.md` for full workflow.
