# Skill: Codebase Onboarding

## Purpose
Structured workflow for learning an unfamiliar codebase from scratch. Produces a mental model, architecture map, convention guide, and populated regression checklist -- everything needed for productive work in future sessions.

## Trigger
- First time working in a new codebase
- After a major rewrite or architectural overhaul
- When context feels thin and understanding is unreliable
- User runs `/onboard` or requests codebase onboarding

## Workflow

### Phase 1: First Contact

Gather surface-level orientation without interpreting anything yet.

1. **Read the README** (or equivalent top-level docs):
   - What does this project do? One sentence.
   - Who is it for? (library consumers, end users, internal team)
   - What claims does the README make about architecture or design philosophy?

2. **Map the directory structure** (top 2 levels):
   - Run `ls` or tree equivalent, capture the layout
   - Categorize directories: source, tests, config, docs, scripts, assets, generated

3. **Read the package manifest** (package.json, Cargo.toml, pyproject.toml, go.mod, etc.):
   - Language and version
   - Dependencies: note the major ones (framework, ORM, test runner, HTTP layer)
   - Scripts/commands: build, test, lint, start

4. **Read config files** (tsconfig, .eslintrc, Dockerfile, CI config, env templates):
   - Build targets and output directories
   - Environment expectations
   - CI/CD pipeline shape

Write orientation summary to `active/active_context.md`:
```
## Codebase Orientation
- Project: [name]
- Stack: [language + framework + database + major deps]
- Entry points: [list]
- Test framework: [name], location: [path]
- Config files: [key files]
- Build/run: [commands]
```

### Phase 2: Architecture Mapping

Understand how the system is organized and how data moves through it.

5. **Find entry points**:
   - Application entry (main, index, app, server)
   - Request handlers / route definitions
   - CLI commands (if applicable)
   - Background job / worker entry points
   - Event listeners or message consumers

6. **Trace the data flow**:
   - Pick the most common operation (e.g., "user makes an API request")
   - Trace it from entry point through middleware, handler, service, data layer, and back
   - Note each layer and what it does
   - Identify where side effects happen (database writes, external calls, events)

7. **Identify key abstractions**:
   - Base classes, interfaces, traits that other code extends
   - Shared types / models / DTOs
   - Middleware or decorator patterns
   - Plugin or extension systems

8. **Map the dependency graph** (conceptual, not package-level):
   - Which modules depend on which?
   - Are there circular dependencies?
   - What is the dependency direction? (does UI depend on data, or vice versa?)

Write architecture summary to `memory/architecture_decisions.md` (append, do not overwrite):
```
## [Project Name] -- Architecture Map
- Layers: [list from outer to inner]
- Data flow: [entry] -> [middleware] -> [handler] -> [service] -> [data]
- Key abstractions: [list with file locations]
- Dependency direction: [description]
- Date mapped: [today]
```

### Phase 3: Convention Discovery

Learn how this codebase expects code to be written.

9. **Naming conventions**:
   - File naming (camelCase, kebab-case, PascalCase, snake_case)
   - Function/method naming
   - Variable naming
   - Class/type naming
   - Constants and enums
   - Read 3-5 representative files to confirm the pattern

10. **Error handling pattern**:
    - Exceptions vs. result types vs. error codes
    - Where are errors caught vs. propagated?
    - Is there a global error handler?
    - How are errors reported to users vs. logged?

11. **State management**:
    - Where does application state live? (database, in-memory, external store)
    - How is state accessed? (direct queries, repository pattern, ORM, cache layer)
    - Is there a caching strategy? Where?

12. **Testing patterns**:
    - Unit test structure (arrange/act/assert, given/when/then)
    - Test file location (co-located, separate tree, both)
    - Mocking strategy (DI, monkey-patching, test doubles)
    - Fixture and factory patterns
    - Integration vs. unit test separation

Record conventions in `active/active_context.md` under a `## Codebase Conventions` heading.

### Phase 4: Guided Exploration

Go beyond structure to understand the living system.

13. **Find the hot paths**:
    - What code runs on every request / every event / every tick?
    - What code runs most frequently? (look at route handlers, event loops, scheduled jobs)
    - These are the paths where performance and correctness matter most

14. **Trace a request end-to-end**:
    - Pick a real, representative request (not the simplest possible one)
    - Follow it through every file it touches
    - Note each transformation, validation, and side effect
    - Record the full path as a reference trace

15. **Identify shared utilities**:
    - Helper functions used across modules
    - Shared middleware, decorators, or wrappers
    - Logging, metrics, and instrumentation utilities
    - These are high-impact change targets -- changes here ripple widely

### Phase 5: Sensitive Area Identification

Find the places where bugs are most likely or most dangerous.

16. **Fragile code**:
    - Code with many dependencies (high fan-in or fan-out)
    - Code that has been changed frequently (check git log if available)
    - Code with complex conditional logic (deeply nested ifs, state machines)
    - Code with implicit assumptions or magic values

17. **Untested code**:
    - Modules or functions with no corresponding tests
    - Critical paths that rely on integration tests only
    - Error handling paths that are never exercised

18. **Complex logic**:
    - Business rules with many branches
    - Data transformations with multiple steps
    - Concurrency or async coordination points
    - Code that mixes concerns (data access + business logic + presentation)

**For each sensitive area found**, add an entry to `active/regression_checklist.md`:
```
### [Area Name]
- Location: [file path(s)]
- Why sensitive: [brief explanation]
- Verification: [how to check this area still works]
- Added: [date] via codebase-onboarding
```

### Phase 6: Mental Model Creation

Synthesize everything into a durable summary.

19. **Write the mental model** as an appendix to `active/active_context.md`:
    ```
    ## Mental Model: [Project Name]

    ### What it does
    [1-2 sentences]

    ### How it works
    [3-5 sentences covering the main flow]

    ### Key things to know
    - [Important architectural decision and why]
    - [Non-obvious convention and where it applies]
    - [Critical shared utility and what depends on it]
    - [Biggest risk area and why]

    ### Where to look
    - To add a feature: [starting points]
    - To fix a bug: [debugging entry points]
    - To understand a domain concept: [key files]
    - To add a test: [test directory, patterns to follow]
    ```

20. **Update session handoff** in `memory/session_handoff.md`:
    - Record that onboarding was completed
    - Note any open questions or areas of low confidence
    - List the files updated during onboarding

## Integration Points

- **Knowledge extraction protocol** (`docs/core/12_knowledge_extraction_protocol.md`): This skill implements and extends that protocol with additional phases for convention discovery, guided exploration, and sensitive area identification.
- **Regression checklist** (`active/regression_checklist.md`): Phase 5 directly populates this with newly discovered sensitive areas.
- **Architecture decisions** (`memory/architecture_decisions.md`): Phase 2 writes the architecture map here for long-term reference.
- **Active context** (`active/active_context.md`): Phases 1, 3, and 6 write orientation, conventions, and the mental model here.

## Anti-Patterns

- Trying to read every file -- focus on representative files, entry points, and hot paths
- Skipping Phase 1 and jumping to code -- surface-level context prevents misinterpretation
- Treating onboarding as optional -- skipping it leads to incorrect assumptions that compound
- Only mapping the happy path -- error handling and edge cases reveal the real architecture
- Not recording what you learned -- the mental model is the deliverable, not just "understanding"
- Onboarding in one pass without verifying -- revisit low-confidence areas before declaring done
