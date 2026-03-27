# State Management -- Summary

Decision framework for classifying state, choosing the right management solution, and applying proven patterns for server, client, URL, form, and derived state. Includes common pitfalls and a debugging approach for tracing state issues.

## When to Use
- Designing state architecture for a new feature or application
- Choosing between state management libraries or patterns
- Refactoring existing state that has become tangled or duplicated
- Debugging stale data, unnecessary re-renders, or state synchronization issues
- Reviewing a component tree for prop drilling or over-centralization

## Key Sections
1. **State Classification** -- Five categories: server, client, URL, form, derived
2. **Decision Framework** -- Flowchart for choosing the right state solution based on category and requirements
3. **Server State Patterns** -- Tanstack Query, SWR, cache invalidation, optimistic updates
4. **Client State Patterns** -- React Context, zustand, signals, and when each is appropriate
5. **URL State** -- Query parameters for shareable/bookmarkable state, nuqs
6. **Form State** -- react-hook-form, controlled vs uncontrolled, validation strategies
7. **Common Pitfalls** -- State duplication, prop drilling, over-centralization, stale closures
8. **Debugging Approach** -- Trace the state chain, identify the source of truth, isolate the problem layer

## Context Cost
Small -- single reference document, no external dependencies.
