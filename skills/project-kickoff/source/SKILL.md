# Skill: Project Kickoff

## Purpose
Structured interview process that deeply understands what the user wants to build, then produces a comprehensive PRD and seeds the Melted Peak memory system with foundational project context.

## Trigger
- New project initialization
- User says `/kickoff`
- Melted Peak is added to a project with no existing PRD or project context

---

## Phase 1: Discovery Interview

Run this interview conversationally. Ask one section at a time, not all at once. Adapt follow-up questions based on answers. The goal is to extract clarity, not fill out a form.

### Round 1: Vision and Purpose

**Start here. Don't skip to technical details.**

1. **What are you building?**
   - Get a one-paragraph description
   - If vague, ask: "Can you describe what a user would do with this?"
   - If too broad, ask: "What's the single most important thing it does?"

2. **Why does this need to exist?**
   - What problem does it solve?
   - Who has this problem? (target users)
   - How are they solving it today? (existing alternatives)
   - What makes this approach better?

3. **What does success look like?**
   - In 1 month? 3 months? 6 months?
   - What metrics would indicate success?
   - What's the minimum viable version that would be useful?

### Round 2: Users and Experience

4. **Who are the users?**
   - Primary user persona (who uses it most)
   - Secondary personas (who else interacts with it)
   - Admin/operator persona (who maintains it)
   - For each: what's their technical level? Their context? Their goals?

5. **What are the core user workflows?**
   - Walk through the 3-5 most important things a user does
   - For each: what triggers it? What steps? What's the outcome?
   - Where do users currently get frustrated or stuck?

6. **What should it NOT do?**
   - Explicit anti-goals (important for preventing scope creep)
   - Features that seem obvious but are intentionally excluded
   - Adjacent problems you're NOT solving

### Round 3: Technical Landscape

7. **What's the tech stack?** (if already decided)
   - Language(s)
   - Framework(s)
   - Database(s)
   - Hosting/infrastructure
   - Key libraries or services
   - If undecided: what are the constraints that inform the choice?

8. **What does the system interact with?**
   - External APIs or services
   - Data sources
   - Authentication providers
   - Third-party integrations
   - Existing systems this must work alongside

9. **What are the hard constraints?**
   - Performance requirements (latency, throughput)
   - Scale expectations (users, data volume)
   - Compliance or regulatory requirements
   - Budget constraints
   - Timeline constraints
   - Platform constraints (browser, mobile, etc.)

### Round 4: Architecture and Decisions

10. **Are there architectural decisions already made?**
    - Monolith vs. microservices
    - Server-rendered vs. SPA vs. hybrid
    - Real-time vs. batch processing
    - Data model approach
    - If not decided, what are the key trade-offs to evaluate?

11. **What are the biggest technical risks?**
    - What could be hard to build?
    - What are you least sure about?
    - Are there dependencies on unproven technology?
    - What would force a major pivot if it doesn't work?

12. **What does the data model look like?**
    - Core entities and their relationships
    - What data is critical vs. derived?
    - Data lifecycle (creation, update, archival, deletion)
    - Privacy considerations

### Round 5: Scope and Priorities

13. **Feature prioritization**
    - Present features mentioned so far in a table
    - Ask user to categorize each as: **Must have** | **Should have** | **Nice to have** | **Won't have (for now)**
    - This uses the MoSCoW method without jargon

14. **What's the build order?**
    - What should be built first?
    - What depends on what?
    - What can be stubbed or mocked early?
    - What's the critical path?

15. **What does v1 look like?**
    - The minimum set of features that makes this usable
    - What's explicitly deferred to v2?
    - What would you ship to one real user?

---

## Phase 2: PRD Generation

After the interview, generate the PRD document.

### Write to `docs/prd.md`

Use the template at `docs/templates/prd_template.md`. Fill in every section from interview answers. Where answers were vague, note the ambiguity explicitly rather than guessing.

### PRD Structure

```markdown
# Product Requirements Document: [Project Name]

## 1. Overview
### 1.1 Vision
### 1.2 Problem Statement
### 1.3 Success Criteria

## 2. Users
### 2.1 Primary Persona
### 2.2 Secondary Personas
### 2.3 User Workflows

## 3. Requirements
### 3.1 Must Have (v1)
### 3.2 Should Have (v1 stretch)
### 3.3 Nice to Have (v2+)
### 3.4 Anti-Goals (explicit exclusions)

## 4. Technical Architecture
### 4.1 Tech Stack
### 4.2 System Diagram
### 4.3 Data Model
### 4.4 External Integrations
### 4.5 Key Architecture Decisions

## 5. Constraints
### 5.1 Performance
### 5.2 Scale
### 5.3 Security and Compliance
### 5.4 Budget and Timeline

## 6. Risks
### 6.1 Technical Risks
### 6.2 Product Risks
### 6.3 Mitigation Strategies

## 7. Build Plan
### 7.1 Phase 1 (MVP)
### 7.2 Phase 2
### 7.3 Phase 3+
### 7.4 Dependency Graph

## 8. Open Questions
[Anything unresolved from the interview]
```

---

## Phase 3: Seed the Memory System

After the PRD is written, populate Melted Peak's memory system:

### 1. Update `active/active_context.md`
- Current goal: Build [project name] per PRD
- Work type: new-feature
- Scope: Phase 1 / MVP features
- Next action: First item from build plan

### 2. Write `memory/project_state.md`
- Overall status: Kickoff complete, PRD written
- Tech stack summary
- Key constraints
- Phase 1 feature list

### 3. Seed `memory/architecture_decisions.md`
Create ADR entries for each decision from Round 4:
- Tech stack choices and rationale
- Architecture decisions and trade-offs
- Data model approach

### 4. Write `memory/feature_registry.md`
List all Phase 1 features with status `planned`:
```markdown
### [feature name]
- **Status**: planned
- **Priority**: must-have | should-have
- **Description**: [from PRD]
- **Dependencies**: [from build plan]
```

### 5. Seed `memory/dependency_map.md`
Document external dependencies identified in Round 3:
- APIs, services, libraries
- Version requirements
- Known quirks or risks

### 6. Update `memory/progress_log.md`
```markdown
### [date] -- Project Kickoff
- **Status**: completed
- **Output**: docs/prd.md
- **Decisions**: [key decisions from interview]
- **Next**: Begin Phase 1 implementation per build plan
```

---

## Phase 4: Generate Initial Skills

Based on the interview, identify if any project-specific skills should be created:

- If the project has a specific deployment process → suggest a deploy skill
- If the project has a specific testing strategy → suggest a testing skill
- If the project has repeated CRUD patterns → suggest a scaffolding skill

Use the **skill-router** skill to create these.

---

## Interview Best Practices

- **Ask one section at a time.** Don't dump all 15 questions at once.
- **Adapt to answers.** If the user has a clear vision, move faster through Round 1. If they're exploring, spend more time there.
- **Push for specificity.** "It should be fast" → "What's the target latency? For which operations?"
- **Capture uncertainty.** "We're not sure yet" is a valid answer. Record it in Open Questions.
- **Don't make decisions for the user.** Present trade-offs and let them choose.
- **Summarize after each round.** "Here's what I understand so far..." to catch misunderstandings early.
- **Skip irrelevant sections.** A simple CLI tool doesn't need persona analysis. A CRUD app doesn't need real-time architecture discussion. Adapt.
