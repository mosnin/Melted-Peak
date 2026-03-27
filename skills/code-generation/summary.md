# Code Generation -- Summary

Structured code generation and scaffolding workflow. Every generated file matches existing project conventions, follows established patterns, and is verified before delivery. Philosophy: "Match what exists, then extend it."

## When to Use
- User requests a new component, endpoint, model, test, or utility
- Scaffolding a new feature or module
- Any task that creates new source files

## Key Steps
1. **Checklist**: Understand requirements, check existing patterns, read project conventions
2. **Pattern Match**: Find similar existing code to use as a structural template
3. **Place**: Determine correct file location based on project structure
4. **Generate**: Scaffold structure first, fill logic, add tests
5. **Verify**: Conventions followed, code compiles, tests pass

## Critical Rules
- Never generate code without first studying existing patterns in the project
- Never guess at naming or file placement -- derive from existing structure
- Always generate tests alongside implementation
- If no similar pattern exists in the project, confirm approach with the user first

## Context Cost
Small -- workflow guide.
