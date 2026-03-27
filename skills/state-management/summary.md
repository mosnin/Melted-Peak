# State Management -- Summary

Decision framework for classifying state and choosing the right management approach. Covers server state, client state, URL state, form state, and derived state with concrete patterns and common pitfalls.

## When to Use
- Designing state architecture for a new feature or application
- Choosing between state management solutions (Tanstack Query vs. zustand vs. Context vs. URL params)
- Refactoring components that have tangled or duplicated state
- Debugging stale data, unnecessary re-renders, or state synchronization issues
- Reviewing code for state management anti-patterns

## Key Sections
1. **State Classification** -- Five categories: server, client, URL, form, derived. Every piece of state belongs to exactly one.
2. **Decision Framework** -- Flowchart-style questions to determine the correct state type and tool for any given data.
3. **Server State Patterns** -- Tanstack Query, SWR, cache invalidation strategies, optimistic updates.
4. **Client State Patterns** -- React Context for low-frequency global state, zustand for frequent updates, signals for fine-grained reactivity.
5. **URL State Patterns** -- Query params for shareable/bookmarkable state, nuqs for type-safe URL state in Next.js.
6. **Form State Patterns** -- react-hook-form, controlled vs. uncontrolled, validation strategies, submission handling.
7. **Derived State** -- Computed values, memoization, when NOT to store state.
8. **Common Pitfalls** -- State duplication, prop drilling, over-centralization, stale closures, premature global state.
9. **State Debugging Approach** -- Trace the state chain, identify the source of truth, verify synchronization points.
10. **Melted Peak Integration** -- Feeds regression checklist, change plan requirements for state architecture changes.

## Context Cost
Small -- single reference document, no external dependencies.
