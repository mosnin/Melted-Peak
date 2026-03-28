# Brainstorming

## Purpose

Socratic design refinement before writing any code. Take a rough idea, explore it through targeted questions, examine alternatives, and produce a written spec that both you and the user have validated — before a single line is written.

## Trigger

- User describes a new feature, product, or capability they want to build
- A task is ambiguous enough that jumping to implementation risks building the wrong thing
- Before creating a change plan for anything non-trivial

## Workflow

### Phase 1: Understand the real problem

Do NOT immediately propose a solution. Instead, ask questions to surface the actual goal:

1. **What problem does this solve?** (not what feature does it add)
2. **Who experiences this problem and when?**
3. **What does success look like from the user's perspective?**
4. **What already exists that's related?** (adjacent code, prior attempts)
5. **What are the constraints?** (tech stack, timeline, existing patterns to follow)

Keep questions short and conversational. Ask 2-3 at a time, not a wall of text.

### Phase 2: Explore alternatives

Before committing to one approach, surface the design space:

- What are 2-3 different ways to solve this?
- What are the tradeoffs of each?
- What do similar systems do?
- What's the simplest version that would prove this works?

Present options as brief comparisons, not long essays.

### Phase 3: Present the design in digestible sections

Once a direction is agreed, present the design in chunks short enough to actually read and validate:

1. **Overview** (2-3 sentences): what it does and why
2. **Scope** (bullet list): what's in, what's explicitly out
3. **Interface / contract**: what the user/caller sees (API shape, UI sketch, data model)
4. **Key decisions**: the non-obvious choices and why they were made
5. **Open questions**: what still needs a decision

Present one section at a time. Wait for feedback before continuing.

### Phase 4: Confirm and document

Once the user approves the full design:

1. Write the spec to `docs/specs/[YYYY-MM-DD]-[feature-name].md`
2. Recommend the next step: create a change plan using `/plan`

## Rules

- **Never start writing code during brainstorming** — the output is a written spec, not an implementation
- **Never skip to solutions** — understanding the problem first prevents building the wrong thing
- **Present in sections** — overwhelming with a full design at once prevents real feedback
- **Socratic, not prescriptive** — guide with questions, don't just declare what to build

## Anti-Patterns

- Jumping to "here's how I'd implement this" without asking questions
- Writing a 500-word design doc all at once without checkpoints
- Treating the first stated requirement as the real requirement
- Skipping alternatives when the first idea seems obvious

## Integration

- **Leads to**: `/plan` (create change plan from the approved spec)
- **Pairs with**: `skills/project-kickoff/` for larger project scoping
- **Output**: `docs/specs/[date]-[name].md`
