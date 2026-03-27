# New Project Setup Prompt

Use when adding Melted Peak to a new project for the first time.

---

## Prompt

```
Set up Melted Peak for this project:

1. Run the codebase-onboarding skill if this is an existing project with code
   OR run the project-kickoff skill (/kickoff) if this is a new project

2. Check peaks/active_peaks.yaml -- are the right peaks mounted for this stack?
   - If the project uses Next.js/React/SaaS → mount modaf-saas if not mounted
   - If the project needs a different peak → check available peaks or create one

3. Seed the memory system:
   - Write initial project_state.md with tech stack, current status
   - Write initial architecture_decisions.md with any known decisions
   - Write initial feature_registry.md with planned/implemented features

4. Set up the active context:
   - Write active_context.md with the current goal
   - Set the work type based on what needs to happen first

5. Run /audit to verify the system is correctly set up

6. Report: system is ready, here's what's loaded, here's the first task
```

## When to Use
- First time using Melted Peak in a project
- After cloning Melted Peak into a new repository
- After a major project pivot that resets context
