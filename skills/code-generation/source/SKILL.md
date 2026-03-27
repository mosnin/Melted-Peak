# Skill: Code Generation

## Purpose
Structured code generation and scaffolding workflow that produces new files matching existing project conventions. Every generated artifact is pattern-matched against the codebase, placed correctly, and verified before delivery.

## Trigger
- User requests a new component, endpoint, model, test, or utility
- Scaffolding a new feature or module
- Context compiler selects work type `new-code` or `scaffold`
- Any task that creates new source files in the project

## Philosophy

> "Match what exists, then extend it."

Code generation is not invention from scratch. It is replication of established patterns with new intent. The generated code should look like it was written by the same team that wrote the rest of the project.

## Workflow

### Phase 1: Pre-Generation Checklist

1. **Understand the requirements**:
   - What is being generated? (component, endpoint, model, test, utility)
   - What is its responsibility? (single, well-defined purpose)
   - What does it interact with? (dependencies, consumers, APIs)
   - Are there acceptance criteria or constraints?

2. **Read project conventions**:
   - Check for style guides, linter configs, or formatter configs in the project root
   - Check peak boot files for convention definitions (if peaks are mounted)
   - Check `memory/metrics/pattern_snapshot.md` if it exists for known project patterns
   - Note: naming conventions, import style, export style, error handling approach

3. **Confirm scope** -- write to `active/change_plan.md`:
   - Files to be created (full paths)
   - Files to be modified (registrations, exports, route tables, etc.)
   - Expected outcome
   - Rollback: delete the created files, revert modifications

### Phase 2: Pattern Matching

4. **Find similar existing code**:
   - Search the codebase for the nearest analogue to what you are generating
   - For a new component: find an existing component of similar complexity
   - For a new endpoint: find an existing endpoint with similar behavior
   - For a new model: find an existing model with similar structure
   - For a new test: find an existing test for a similar unit
   - For a new utility: find an existing utility with similar scope

5. **Extract the pattern**:
   - File structure (imports, declarations, exports)
   - Naming conventions (PascalCase, camelCase, snake_case, file naming)
   - Error handling approach (try/catch, Result types, error codes)
   - Documentation style (JSDoc, docstrings, comments)
   - Test structure (setup, arrange-act-assert, teardown)

6. **If no similar pattern exists**:
   - STOP and confirm the approach with the user
   - Propose a structure based on language/framework conventions
   - Get explicit approval before generating

### Phase 3: File Placement

7. **Determine where the code goes**:
   - Study the project directory structure
   - Follow existing organizational patterns:
     | Code Type | Typical Location Pattern |
     |-----------|-------------------------|
     | Component | Near related components, in a feature or shared directory |
     | Endpoint/Route | In the routes/controllers/handlers directory |
     | Model/Entity | In the models/entities directory |
     | Test | Mirror the source path under a test directory, or co-located |
     | Utility | In a utils/helpers/lib directory |
   - Match the existing convention exactly -- do not invent new locations

8. **Check for registration points**:
   - Does the new code need to be registered somewhere? (route table, module index, DI container)
   - Does an index/barrel file need updating?
   - Does a configuration file need a new entry?

### Phase 4: Generation

9. **Scaffold structure first**:
   - Create the file with imports, type signatures, function/class shells, and exports
   - Do NOT fill in logic yet
   - Verify the scaffold compiles/parses cleanly

10. **Fill in logic**:
    - Implement the core behavior
    - Follow the error handling pattern from the matched template
    - Use consistent naming derived from the pattern

11. **Add tests**:
    - Create test file following the project test structure
    - Cover the primary path and at least one error/edge case
    - Use the same assertion style and test utilities as existing tests

12. **Update registration points**:
    - Add to index/barrel files
    - Register routes, modules, or dependencies as needed
    - Update any configuration that references the new code

### Phase 5: Post-Generation Verification

13. **Convention check**:
    - Does the naming match the project convention?
    - Do imports follow the project style? (relative vs absolute, ordering)
    - Does the export style match? (default vs named, module pattern)
    - Does the error handling follow the project pattern?
    - Are there no leftover placeholders or TODO comments?

14. **Build and test**:
    - Run the linter/formatter if configured
    - Run the type checker if applicable
    - Run the new tests -- they must pass
    - Run related existing tests -- they must still pass

15. **Update the system**:
    - Update `memory/recent_deltas.md` with all files created and modified
    - Close the change plan with outcomes
    - If this established a new pattern, log in `memory/metrics/pattern_journal.md`

## Common Generation Tasks

### New Component
1. Find an existing component of similar scope
2. Replicate its file structure, imports, and export pattern
3. Place in the same directory level as siblings
4. Add to any component index or registry

### New API Endpoint
1. Find an existing endpoint with similar HTTP method and behavior
2. Replicate route definition, handler signature, validation, and response shape
3. Add to the route table or router configuration
4. Generate request/response types if the project uses them
5. Add integration or handler test

### New Model/Entity
1. Find an existing model with similar field complexity
2. Replicate field definitions, validation rules, and serialization
3. Add migration if the project uses database migrations
4. Add to any model index or ORM registration

### New Test File
1. Find an existing test for a unit of similar complexity
2. Replicate setup/teardown, import style, and assertion patterns
3. Co-locate or mirror-locate based on project convention
4. Include at least: one happy path, one error case, one edge case

### New Utility
1. Find an existing utility with similar scope
2. Replicate the function signature style and documentation pattern
3. Place in the appropriate utils/helpers directory
4. Export from the index file if one exists
5. Write unit tests with focused input/output coverage

## Common Mistakes

- **Generating from memory instead of from patterns**: Always search the codebase first. Your assumptions about conventions may be wrong.
- **Placing files in new locations**: If every other component is in `src/components/`, do not create `src/new-components/`.
- **Inconsistent naming**: If the project uses `UserService` not `userService`, match it exactly.
- **Forgetting registration**: New code often needs to be wired into a registry, router, or index file.
- **Skipping tests**: Every generated implementation file gets a corresponding test file.
- **Over-generating**: Generate only what was requested. Do not add speculative utilities or abstractions.
