# Skill: Skill Router

## Purpose
Meta-skill that detects opportunities for new project-specific skills and guides their creation. Makes the Melted Peak system self-evolving -- it learns from the project's unique workflows and codifies them into reusable skills.

## Trigger
- User says `/new-skill` or asks to create a skill
- Claude recognizes a repeated workflow pattern (3+ times doing the same sequence)
- User describes a workflow they want automated or standardized
- During retrospective or handoff, a reusable pattern is identified

---

## Part 1: Pattern Detection

### Recognizing Skill Opportunities

A workflow should become a skill when:
- You've done the same sequence of steps **3 or more times** in a project
- The steps are specific enough to be documented but general enough to reuse
- The workflow has decision points that benefit from a checklist
- Mistakes have occurred because the workflow wasn't followed consistently

### Signals to Watch For

During normal work, watch for these patterns:

| Signal | Example | Potential Skill |
|--------|---------|-----------------|
| Repeated file sequences | "Every time we add an API endpoint, we touch routes, controller, types, tests" | `api-endpoint-creation` |
| Repeated checks | "Before every deploy, we check migrations, env vars, and feature flags" | `pre-deploy-checklist` |
| Complex procedures | "Updating the auth flow requires 7 coordinated changes" | `auth-flow-update` |
| Error-prone processes | "We keep forgetting to update the OpenAPI spec when changing endpoints" | `api-change-protocol` |
| Onboarding knowledge | "New features always need these 5 things configured" | `feature-scaffolding` |

### When NOT to Create a Skill

- The workflow has only been done once (wait for repetition)
- The workflow is entirely project-generic (check if a built-in skill already covers it)
- The workflow is a one-time migration or setup task
- The "skill" is really just a single command (that's a script, not a skill)

---

## Part 2: Skill Design Interview

When a skill opportunity is identified, run this interview to design it:

### Question 1: What Does This Skill Do?
Capture in one sentence. This becomes the `description` in the manifest.

### Question 2: When Should It Activate?
List the conditions. These become the `triggers` in the manifest.
- What user action or situation triggers this workflow?
- Is it triggered by a file change, a command, a work type?

### Question 3: What Are the Steps?
Walk through the workflow step by step:
- What's the first thing you do?
- What decisions do you make along the way?
- What files do you read/write/modify?
- What checks do you run?
- What's the definition of "done"?

### Question 4: What Goes Wrong?
Identify the failure modes:
- What mistakes have been made doing this manually?
- What steps are most commonly skipped?
- What's the recovery path when something fails?

### Question 5: What Does It Depend On?
- Does it need specific frameworks or knowledge packs loaded?
- Does it require other skills to run first?
- Does it require specific project files or config to exist?

### Question 6: How Project-Specific Is It?

| Scope | Meaning | Location |
|-------|---------|----------|
| **Universal** | Works in any project | `skills/` (can be shared) |
| **Stack-specific** | Works for projects with the same tech stack | `skills/` with stack tags |
| **Project-specific** | Only works in this exact project | `skills/` with project tag |

---

## Part 3: Skill Generation

### Step 1: Create the Directory
```
skills/[skill-name]/
├── source/
│   └── SKILL.md
├── manifest.yaml
└── summary.md
```

### Step 2: Write SKILL.md

Use this structure for the generated skill:

```markdown
# Skill: [Name]

## Purpose
[One sentence from Question 1]

## Trigger
[From Question 2]

## Prerequisites
[From Question 5 -- what must exist before this skill runs]

## Workflow

### Step 1: [First action]
[Detailed instructions]
- What to check
- What to read
- Decision criteria

### Step 2: [Next action]
...

### Step N: Verification
[How to confirm the skill completed successfully]

## Common Mistakes
[From Question 4]
- [Mistake 1] -- [How to avoid it]
- [Mistake 2] -- [How to avoid it]

## Rollback
[How to undo if the workflow creates problems]
```

### Step 3: Write manifest.yaml

Fill in from the interview answers:
- `name`: from the skill name (lowercase, hyphens)
- `description`: from Question 1
- `triggers`: from Question 2
- `dependencies`: from Question 5
- `tags`: from Question 6 scope + domain tags
- `context_cost`: estimate based on SKILL.md length
- `status`: set to `draft` initially

### Step 4: Write summary.md

Condense the SKILL.md into:
- What it does (2-3 sentences)
- When to use it
- Key steps (bullet list)
- Common mistakes to avoid

### Step 5: Register

1. Add entry to `docs/registry/skill_index.yaml`
2. Update `docs/registry/dependency_map.md` if dependencies exist
3. Log creation in `memory/change_log.md`

### Step 6: Test Run

Execute the skill once on a real case:
- Did the steps make sense in practice?
- Were any steps missing?
- Was the order correct?
- Adjust based on findings

### Step 7: Promote

If the test run passes:
- Update manifest status from `draft` to `ready`
- Update the registry entry

---

## Part 4: Skill Evolution

Skills aren't static. Update them when:
- A step is consistently skipped (remove it or make it conditional)
- A new failure mode is discovered (add to Common Mistakes)
- The project's tooling changes (update commands/paths)
- A skill is superseded by a better approach (mark `deprecated`, create replacement)

### Version Bumping
- Patch (1.0.x): Clarification, typo fix, minor rewording
- Minor (1.x.0): New step added, new failure mode documented
- Major (x.0.0): Workflow fundamentally changed, steps reordered/removed

---

## Part 5: Skill Composition

Skills can reference other skills:
```markdown
### Step 3: Review Changes
Execute the **code-review** skill (standard depth) on all modified files.
```

When composing skills:
- Reference by name, not by inlining the content
- The context compiler will load both skills when the parent is triggered
- Add the referenced skill as a dependency in the manifest
