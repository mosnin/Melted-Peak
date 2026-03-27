# Skill: Documentation Generation

## Purpose
Structured workflows for generating and maintaining project documentation -- READMEs, API docs, ADRs, changelogs, code comments, user guides, and contributing guidelines. Ensures documentation stays accurate, useful, and proportional to the complexity it describes.

## Trigger
- When the user requests documentation for a project or component
- When a feature ships and needs user-facing docs
- When an architectural decision is made and needs recording
- When preparing a release (changelog, migration guide)
- When onboarding materials need creation or updating

---

## Section 1: README Generation

### When to Write
Every project or standalone module needs a README. If someone clones the repo and has no idea what to do, the README has failed.

### Structure
1. **Project name and one-line description** -- what is this and why does it exist?
2. **Status badges** (optional) -- build, coverage, version
3. **Quick start** -- fewest steps to get running locally
4. **Prerequisites** -- runtime, tools, accounts needed before setup
5. **Installation** -- step-by-step, copy-pasteable commands
6. **Usage** -- the most common operations with examples
7. **Configuration** -- environment variables, config files, defaults
8. **Project structure** (for non-trivial projects) -- key directories and what lives there
9. **Contributing** -- link to CONTRIBUTING.md or inline summary
10. **License** -- name and link

### Guidelines
- Write for someone who has never seen the project
- Every command should be copy-pasteable -- no placeholder values without explanation
- Keep the quick start under 5 steps
- If setup takes more than a page, something is wrong with the setup, not the docs
- Update the README when installation steps, dependencies, or core usage patterns change

---

## Section 2: API Documentation

### Auto-Generation from Code
- Use code annotations as the source of truth: JSDoc/TSDoc for JavaScript/TypeScript, docstrings for Python, GoDoc for Go
- Auto-generate reference docs from these annotations -- do not maintain a separate copy
- Every public function, method, class, and type should have:
  - A one-line summary of what it does
  - Parameter descriptions with types and constraints
  - Return value description
  - Thrown errors or failure modes
  - A usage example for non-obvious APIs

### OpenAPI / REST APIs
- Maintain an OpenAPI spec as the single source of truth for HTTP APIs
- Generate the spec from code annotations where possible (avoid hand-writing large specs)
- Include for each endpoint:
  - HTTP method and path
  - Request parameters (path, query, header, body) with types and constraints
  - Response schemas for success and error cases
  - Authentication requirements
  - Rate limiting details
  - At least one request/response example pair

### Example Quality
- Examples should be realistic, not `foo`/`bar`/`baz`
- Show the most common use case first
- Show error handling in at least one example
- Examples must be tested or validated -- stale examples are worse than no examples

---

## Section 3: Architecture Decision Records (ADRs)

### Format
Use the following structure for each ADR:

```
# ADR-NNN: Title

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-NNN]

## Context
What is the problem or situation that requires a decision?

## Decision
What did we decide and why?

## Consequences
What are the positive, negative, and neutral outcomes of this decision?

## Alternatives Considered
What other options were evaluated and why were they rejected?
```

### When to Write an ADR
- Choosing a framework, library, or major dependency
- Changing the system's data model or storage layer
- Adopting or abandoning an architectural pattern
- Making a decision that would be expensive to reverse
- When someone asks "why did we do it this way?" more than once

### When NOT to Write an ADR
- Routine dependency updates
- Style or formatting choices (those belong in linter config)
- Decisions that are trivially reversible

### Maintenance
- ADRs are immutable once accepted -- do not edit the decision after the fact
- If a decision is reversed, write a new ADR that supersedes the old one
- Link ADRs to each other when they are related
- Store ADRs in a numbered sequence for easy reference

---

## Section 4: Changelog Generation

### Format
Follow Keep a Changelog conventions:
- **Added** -- new features
- **Changed** -- changes to existing functionality
- **Deprecated** -- features that will be removed
- **Removed** -- features that have been removed
- **Fixed** -- bug fixes
- **Security** -- vulnerability fixes

### From Conventional Commits
If the project uses conventional commits (`feat:`, `fix:`, `chore:`, etc.):
1. Group commits by type into changelog categories
2. Rewrite commit messages for a user audience -- the changelog reader is not the commit reader
3. Strip internal details (refactors, CI tweaks) unless they affect users
4. Link to issues or PRs where relevant

### Keeping It Useful
- Write entries from the user's perspective: "You can now export reports as CSV" not "Added CSV serializer to ReportService"
- Group related changes under a single entry instead of listing every commit
- Call out breaking changes prominently at the top of the version entry
- Include migration instructions for breaking changes inline or linked

---

## Section 5: Code Documentation

### When to Add Comments
- **Why, not what**: Comment on the reason behind non-obvious decisions, not what the code literally does
- **Workarounds**: If code works around a bug, link to the issue tracker
- **Constraints**: If a value is hardcoded for a non-obvious reason, explain the constraint
- **Algorithms**: If implementing a non-trivial algorithm, name it and link to a reference
- **Regex**: Always comment complex regular expressions with what they match

### When NOT to Comment
- Self-evident code: `i++; // increment i` adds nothing
- Restating the function name: `// Gets the user` above `getUser()` is noise
- Commented-out code: delete it; version control remembers
- TODO without context: `// TODO: fix this` is useless; include what and why

### Docstrings and Type Annotations
- Every public API element gets a docstring
- Internal helpers get docstrings if their name is not self-explanatory
- Use the language's standard format: JSDoc for JS/TS, Google/NumPy style for Python, GoDoc for Go
- Type annotations reduce the need for parameter documentation -- use them

---

## Section 6: User Guides and Tutorials

### Structure
1. **Start with the goal**: "By the end of this guide, you will have..."
2. **Prerequisites**: What the reader needs before starting
3. **Steps**: Numbered, each step does one thing, each step has a verifiable outcome
4. **Verification**: How to confirm each step worked
5. **Troubleshooting**: Common failures and fixes at the end or inline
6. **Next steps**: Where to go after completing the guide

### Progressive Disclosure
- Start with the simplest possible use case
- Layer complexity: basics first, then configuration, then advanced topics
- Link to deeper docs rather than inlining everything
- A tutorial should take the reader from zero to working in under 15 minutes -- if it takes longer, split it

### Anti-Patterns
- Wall of text with no code examples
- Assuming knowledge that the prerequisites do not list
- Screenshots without alt text or descriptions
- Tutorials that require the reader to understand the entire system before starting

---

## Section 7: Contributing Guidelines

### Structure for CONTRIBUTING.md
1. **How to report a bug** -- what information to include
2. **How to suggest a feature** -- where to propose, what to include
3. **Development setup** -- getting the project running locally for development
4. **Code standards** -- link to linter config, style guide, or describe conventions
5. **Testing expectations** -- what tests are required for PRs, how to run them
6. **PR process** -- branch naming, commit message format, review expectations, merge strategy
7. **Code of conduct** -- link or inline

### Guidelines
- Be specific about what "good" looks like: "Include a test for each new public function" not "Write tests"
- Include the commands to run the test suite, linter, and formatter
- State the expected response time for PR reviews
- Describe what will cause a PR to be rejected

---

## Section 8: Documentation Maintenance

### Detecting Stale Documentation
Docs go stale when:
- The code changes but the docs do not
- A dependency is upgraded and the setup steps change
- A feature is removed but its documentation remains
- Configuration defaults change

### Update Triggers
Documentation should be reviewed when:
- A public API signature changes
- Installation or setup steps change
- A feature is added, changed, or removed
- A new dependency is added or a major version is bumped
- The deployment process changes

### Practices
- Treat docs as code: they live in the repo, they get reviewed in PRs, they get tested
- Add a docs checklist item to PR templates: "Does this change require a documentation update?"
- Periodically audit links in documentation for 404s
- If a doc has not been updated in 6+ months and describes active code, verify it is still accurate

---

## Section 9: When NOT to Document

Not everything needs documentation. Unnecessary documentation is worse than none because it creates maintenance burden and can mislead when it goes stale.

### Do Not Document
- **Self-evident code**: Well-named functions with clear types are their own documentation
- **Internal implementation details**: Private methods, internal state transitions, module-internal wiring -- these change frequently and documenting them couples readers to implementation
- **Obvious patterns**: If the project uses a standard framework in a standard way, do not rewrite the framework's docs
- **Ephemeral decisions**: Sprint-level choices that will change next week do not need ADRs
- **Generated code**: Document the generator and its config, not its output

### The Test
Before writing documentation, ask:
1. Who will read this? If the answer is "nobody" or "only me, and I will remember," skip it.
2. Will this be accurate in 3 months? If not, it may cause more harm than good.
3. Is there a better place for this information? (Type system, test names, error messages)

---

## Section 10: Integration with Melted Peak

Documentation generation connects to several Melted Peak components:

### change_log.md
- After generating or updating documentation, log the change in `memory/change_log.md`
- Include what was documented, why, and what triggered the documentation update

### architecture_decisions/
- ADRs generated by this skill should be stored in the project's architecture decisions directory
- Cross-reference ADRs with entries in `memory/architecture_decisions/` when the decision affects the Melted Peak system itself

### feature_registry
- When documenting a new feature, check `docs/registry/` for existing component entries
- Use registry metadata (description, dependencies, status) as input to documentation
- Update the registry entry's documentation references after generating docs

### active_context.md
- After generating documentation, update `active/active_context.md` to reflect what was documented
- Note any documentation gaps discovered during generation for future work

### Workflow
1. Read the relevant registry entries and change log to understand what needs documenting
2. Generate the appropriate documentation type (README, API docs, ADR, etc.)
3. Log the documentation change in `memory/change_log.md`
4. Update `active/active_context.md` with documentation status
5. If documentation gaps were found, log them in `memory/known_issues.md`

---

## Anti-Patterns

- Writing documentation after the fact and guessing at intent -- document while the decision context is fresh
- Duplicating information across multiple docs -- single source of truth, link everywhere else
- Documenting what the code does line-by-line instead of why it exists
- Writing docs nobody asked for to feel productive
- Treating documentation as a one-time task instead of an ongoing practice
- Perfect formatting with wrong content -- accuracy beats aesthetics every time
