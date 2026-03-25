# Ingestion and Normalization Rules

Defines how new frameworks, skills, and knowledge packs are added to the system safely and consistently.

---

## Rule: Nothing Raw May Be Used

Raw files -- documentation, guides, references -- cannot be used directly. They must be normalized into the standard component structure before being referenced in active work.

## Ingestion Workflow

### Step 1: Receive Raw Material

Place raw files in `incoming/`. This is a staging area -- nothing here is part of the system yet.

Acceptable inputs:
- Documentation files (markdown, PDF, text)
- Code repositories or snippets
- API references
- Design patterns or architectural guides
- Workflow descriptions

### Step 2: Classify the Component

Determine what type of component this will become:

| Type | Criteria | Destination |
|------|----------|-------------|
| **Peak** | Comprehensive domain sub-system with its own skills, knowledge, templates, and conventions (e.g., a full frontend or backend system) | `peaks/[name]/` -- use the peak manager skill (`/peak import`) |
| **Framework** | Large, comprehensive system (architecture patterns, testing strategies, full methodologies) | `frameworks/[name]/` |
| **Skill** | Focused workflow capability (debugging protocol, review checklist, deployment procedure) | `skills/[name]/` |
| **Knowledge** | Reference material (API docs, domain expertise, best practices) | `knowledge/[name]/` |

**Note**: If the incoming material is comprehensive enough to contain its own workflows, conventions, and reference material for an entire domain, it is a **Peak**, not a Framework. Use `/peak import` instead of the standard ingestion workflow. See `docs/peaks/peak_system.md`.

### Step 3: Normalize

Create the required three files for the component:

#### Source File(s)
- For frameworks: `frameworks/[name]/source/` directory with organized documentation
- For skills: `skills/[name]/source/SKILL.md` with the workflow logic
- For knowledge: `knowledge/[name]/source/` directory with reference material

Normalization rules for source:
- Remove redundant or duplicate content
- Organize into clear sections
- Add cross-references to other Melted Peak components where relevant
- Preserve the original intent and accuracy

#### Manifest (`manifest.yaml`)
Create using the appropriate template from `docs/templates/`. Required fields:
- `name`: Unique identifier (lowercase, hyphens)
- `version`: Semantic version (start at 1.0.0)
- `status`: Set to `draft` initially
- `description`: One-line summary
- `context_cost`: Estimate as `small`, `medium`, or `large`
- `dependencies`: List any required co-components
- `tags`: For searchability

#### Summary (`summary.md`)
Write a short operational overview:
- What the component does (2-3 sentences)
- When to use it (conditions)
- Key concepts (bullet points)
- Dependencies (if any)

Target: readable in under 60 seconds.

### Step 4: Validate Structure

Verify the component has all required files using the readiness gate (`docs/core/11_readiness_gate.md`).

### Step 5: Register

Add the component to the appropriate registry index:
- `docs/registry/framework_index.yaml` for frameworks
- `docs/registry/skill_index.yaml` for skills
- `docs/registry/knowledge_index.yaml` for knowledge

Update `docs/registry/dependency_map.md` if the component has dependencies.

### Step 6: Promote

Move the component from `incoming/` to its destination directory. Update manifest status from `draft` to `ready`.

### Step 7: Clean Up

Remove the raw files from `incoming/`.

---

## Normalization Quality Standards

- Source must be self-contained (no broken references to external files)
- Manifest must have all required fields populated
- Summary must be concise and actionable
- Component name must be unique across all registries
- Tags must use existing vocabulary where possible (check other manifests)
