# Skill: State Management

## Purpose
Decision framework for classifying application state, choosing the right management solution, and applying proven patterns. Covers server state, client state, URL state, form state, and derived state. Focused on making the right architectural choice rather than API reference.

## Trigger
- Designing state architecture for a new feature or application
- Choosing between state management approaches or libraries
- Refactoring tangled, duplicated, or poorly structured state
- Debugging stale data, synchronization bugs, or unnecessary re-renders

---

## 1. State Classification

Every piece of state in an application belongs to one of five categories. Misclassifying state is the root cause of most state management problems.

### The Five Categories

| Category | Definition | Examples | Owner |
|----------|-----------|----------|-------|
| **Server state** | Data that lives on the server and is cached on the client | User profile, product list, order history | The server (client has a cache) |
| **Client state** | Data that exists only in the browser and has no server representation | Modal open/closed, sidebar collapsed, selected tab | The client |
| **URL state** | Data encoded in the URL for shareability and navigation | Search query, active filters, pagination page, selected item ID | The URL |
| **Form state** | Data being actively edited by the user before submission | Input values, validation errors, dirty/touched status | The form |
| **Derived state** | Data computed from other state -- never stored independently | Filtered list, total price, "has unsaved changes" flag | Computed on read |

### Classification Checklist
When you encounter a piece of state, ask:
1. Does this data come from the server? -> **Server state**
2. Should this survive a page refresh or be shareable via URL? -> **URL state**
3. Is the user actively editing this before submission? -> **Form state**
4. Can this be computed from other state that already exists? -> **Derived state**
5. Is this purely local UI state with no other home? -> **Client state**

### The Cardinal Rule
**Never store server state in client state.** If data originates from the server, manage it with a server-state tool (Tanstack Query, SWR). Copying server data into useState or a global store creates a synchronization problem that only gets worse over time.

---

## 2. Decision Framework

Use this flowchart after classifying the state:

```
Does the data come from the server?
  YES -> Use a server-state library (Tanstack Query / SWR)
  NO  -> Continue

Should this state be in the URL (shareable, bookmarkable, back-button)?
  YES -> Use URL state (query params via nuqs, or router state)
  NO  -> Continue

Is this form data being edited before submission?
  YES -> Use a form library (react-hook-form) or local component state
  NO  -> Continue

Can this be computed from existing state?
  YES -> Derive it (useMemo, computed selector, getter function). Do NOT store it.
  NO  -> Continue

How many components need this state?
  1-2 nearby components -> useState + props (simplest possible solution)
  A subtree of components -> React Context (scoped provider)
  Many components across the tree -> Client state library (zustand, signals)
```

### Choosing the Simplest Solution
Always start with the simplest tool that works. Escalate only when the simpler approach creates real problems (not hypothetical ones).

**Escalation ladder for client state:**
1. `useState` in the component that owns it
2. Lift state to the nearest common parent, pass via props
3. Composition / compound components to avoid prop threading
4. React Context for a subtree that shares state
5. External store (zustand) for truly global cross-cutting state

Do not skip steps. Most state never needs to go past step 2.

---

## 3. Server State Patterns

Server state is the most common source of complexity. Use a dedicated library.

### Why a Server-State Library
Managing server data with useState + useEffect means manually handling:
- Loading/error states
- Caching and cache invalidation
- Deduplication of concurrent requests
- Background refetching and staleness
- Optimistic updates and rollbacks
- Pagination and infinite scroll

Server-state libraries (Tanstack Query, SWR) handle all of this out of the box.

### Tanstack Query Core Concepts
- **Queries** (`useQuery`): Declarative data fetching tied to a cache key. The cache key determines identity and deduplication.
- **Mutations** (`useMutation`): Write operations with `onSuccess`, `onError`, `onSettled` callbacks for cache updates.
- **Query keys**: Serializable arrays that uniquely identify data. Include all variables that affect the result: `['todos', { status, page }]`.
- **Stale time**: How long cached data is considered fresh. During this window, the cache is returned without a network request. Default is 0 (always stale).
- **Cache time (gcTime)**: How long unused cache entries stay in memory before garbage collection. Default is 5 minutes.

### Cache Invalidation Strategies

| Strategy | When to Use | How |
|----------|------------|-----|
| **Invalidation** | After a mutation, refetch related queries | `queryClient.invalidateQueries({ queryKey: ['todos'] })` |
| **Optimistic update** | When you want instant UI feedback | Update cache before mutation, rollback on error |
| **Direct cache update** | When the mutation response contains the new data | `queryClient.setQueryData(['todo', id], newTodo)` |
| **Polling** | For data that changes externally (dashboards, feeds) | `refetchInterval: 5000` |

### Optimistic Updates Pattern
```
1. Cancel in-flight queries for the same key
2. Snapshot the current cache value (for rollback)
3. Optimistically set the new cache value
4. Perform the mutation
5. On error: rollback to the snapshot
6. On settled (success or error): invalidate to ensure consistency
```

Key rule: always invalidate on settled, even after a successful optimistic update. The server is the source of truth.

**When NOT to use optimistic updates**: financial transactions, irreversible actions, complex multi-entity mutations where rollback state is ambiguous.

### SWR
SWR follows a similar model with a "stale-while-revalidate" strategy. Use it when you want a lighter-weight option. The core concepts (cache keys, revalidation, mutation) are analogous to Tanstack Query.

---

## 4. Client State Patterns

Client state is UI-only state with no server representation. The goal is to keep it as local as possible.

### React Context
**When to use:**
- A subtree of components needs to share state (theme, auth status, locale)
- The state changes infrequently
- You need dependency injection (swapping implementations for testing)

**When NOT to use:**
- Frequently changing values (causes re-renders of every consumer)
- State that only 1-2 components need (just use props)
- As a replacement for a server-state library

**Pattern: Split context into state and dispatch.**
Separate the value that changes frequently from the dispatch function that is stable. This prevents unnecessary re-renders of components that only dispatch actions.

### Zustand
**When to use:**
- Truly global cross-cutting state (multiple unrelated parts of the app need it)
- Frequently updating state where Context re-renders are a problem
- State that benefits from selectors (components subscribe to slices)
- State shared across React and non-React code

**Key advantages:**
- No provider required (works outside the React tree)
- Selector-based subscriptions (components only re-render when their slice changes)
- Minimal boilerplate
- Works with React DevTools via middleware

**Pattern: Keep stores small and focused.**
One store per domain concern, not one mega-store. A `useCartStore` and a `useUIStore`, not a single `useAppStore`.

### Signals (Preact Signals, Angular Signals, Solid)
**When to use:**
- Fine-grained reactivity is needed (update a single DOM node without re-rendering the component)
- Framework supports them natively (Solid, Preact, Angular)
- Performance-critical scenarios where React's re-render model is too coarse

**When NOT to use:**
- Standard React applications (signals are not idiomatic React; use selectors or memo instead)
- When the team is not familiar with the reactive programming model

### Decision Table: Client State Solutions

| Need | Solution |
|------|----------|
| State used by one component | `useState` |
| State shared between parent-child | Props |
| State shared in a subtree, changes rarely | React Context |
| State shared widely, changes often | Zustand (selector-based) |
| Fine-grained DOM updates, non-React | Signals |

---

## 5. URL State

State that belongs in the URL:
- Search queries and filters
- Pagination (page number, page size)
- Selected tab or view mode
- Sort order
- Item IDs for deep linking

### Why URL State Matters
- **Shareability**: Users can share a link and the recipient sees the same view
- **Bookmarkability**: Users can bookmark a filtered view and return to it
- **Back button**: Browser navigation works correctly
- **SEO**: Search engines can index filtered/paginated views

### Implementation with nuqs
nuqs provides type-safe query parameter state management for Next.js:
- Parses and serializes query params with type safety
- Supports default values, shallow routing, and history push vs replace
- Integrates with the Next.js router

### URL State Principles
- **Serialize only what is needed**: Do not put large objects in the URL. Use IDs and look up the rest.
- **Use sensible defaults**: If a query param is absent, the app should show a reasonable default state. Do not require every param to be present.
- **Choose push vs replace carefully**: Use `push` when the user should be able to go back (navigating to a new filter). Use `replace` when the state change is a refinement (typing in a search box).
- **Validate on read**: URL params are user input. Parse and validate them. Malformed params should fall back to defaults, not crash.

---

## 6. Form State

### Controlled vs Uncontrolled

| Approach | How | When |
|----------|-----|------|
| **Controlled** | React state drives the input value (`value` + `onChange`) | Need real-time validation, conditional logic based on input, formatting as user types |
| **Uncontrolled** | DOM owns the value, read via `ref` or `FormData` on submit | Simple forms, file inputs, when performance matters (avoids re-render per keystroke) |

### react-hook-form
**When to use:**
- Forms with validation requirements
- Forms with many fields (performance advantage from uncontrolled approach)
- Dynamic forms (add/remove fields)
- Forms that need dirty tracking, touched status, submission state

**Key concepts:**
- `register`: Connects a field to the form (uncontrolled by default, performant)
- `handleSubmit`: Validates and calls your submit function
- `formState`: Provides `errors`, `isDirty`, `isSubmitting`, `isValid`
- `watch`: Subscribe to field values for conditional logic (use sparingly -- causes re-renders)
- `Controller`: Wraps controlled components (select, datepicker) for integration

### Validation Strategy

| Layer | Tool | Purpose |
|-------|------|---------|
| Schema definition | zod | Single source of truth for shape and constraints |
| Form integration | @hookform/resolvers/zod | Connects zod schema to react-hook-form |
| Server validation | Same zod schema | Reuse on the server for defense in depth |

**Rules:**
- Always validate on the server. Client validation is a UX convenience, not a security measure.
- Show field-level errors next to the field, not just at the top of the form.
- Validate on blur for long forms (avoids frustrating the user while they type). Validate on submit for short forms.
- Do not clear the form on validation error. Preserve the user's input.

### Form State Boundary
Form state should not leak into global state. A form's values are ephemeral -- they exist while the user is editing and are consumed on submission. After submission, the result is server state (managed by the server-state library) or a navigation event.

---

## 7. Common Pitfalls

### State Duplication
**Symptom**: The same data exists in two places that can get out of sync.
**Common cause**: Copying server data into useState, storing derived values.
**Fix**: Identify the single source of truth. If it is on the server, use a server-state library. If it can be computed, derive it.

### Prop Drilling
**Symptom**: State is passed through many intermediate components that do not use it.
**Common cause**: State is owned too high in the tree, or composition patterns are not used.
**Fix (in order of preference)**:
1. Move state closer to where it is used
2. Use composition (pass components as children/props instead of data)
3. Use React Context for the subtree
4. Use an external store only if the above fail

### Over-Centralization
**Symptom**: A single global store contains everything -- UI state, server cache, form data.
**Common cause**: Treating Redux/zustand as the default for all state.
**Fix**: Classify the state (Section 1). Move server state to a server-state library. Move form state to a form library. Move URL state to the URL. What remains for the global store is usually very small.

### Stale Closures
**Symptom**: An event handler or effect captures an old value of state or props.
**Common cause**: Missing dependencies in useEffect/useCallback, or using state inside a setTimeout/setInterval without a ref.
**Fix**:
- Ensure dependency arrays are complete (use the linter)
- Use refs for values that need to be read in callbacks without re-creating the callback
- Use the functional form of setState (`setCount(prev => prev + 1)`) instead of reading the variable
- For intervals/timeouts, store the latest value in a ref and read from the ref inside the callback

### Unnecessary Re-renders from State
**Symptom**: Components re-render when state they do not use changes.
**Common cause**: Storing unrelated state in the same object, using Context for frequently changing values without splitting.
**Fix**:
- Split Context into separate providers for values that change at different rates
- Use zustand selectors to subscribe to specific slices
- Use `React.memo` at the boundary where props stop changing
- Avoid creating new object/array references on every render (memoize or hoist)

---

## 8. State Debugging Approach

When state behaves unexpectedly, follow this sequence:

### Step 1: Identify the Source of Truth
Ask: where should this data come from? Server? URL? Local state? If you cannot answer this question, the architecture has a classification problem (see Section 1).

### Step 2: Trace the State Chain
Follow the data from source to the UI that renders it:
1. Where is the state defined/fetched?
2. How does it flow to the component that renders it? (props, context, selector, hook)
3. What transforms or derives from it along the way?
4. What triggers updates to it? (user action, server response, effect)

### Step 3: Check for Duplication
Is the same data stored in more than one place? If yes, which copy is stale? The fix is usually to eliminate the duplicate and read from the single source.

### Step 4: Check Timing
- Is an effect running at the wrong time? (missing or extra dependencies)
- Is a mutation updating the cache before/after it should?
- Is a stale closure capturing an old value?

### Step 5: Isolate the Layer
Narrow down which layer is broken:
- **Fetching**: Is the network request returning the right data? (check Network tab)
- **Caching**: Is the cache key correct? Is the cache stale? (check React Query DevTools)
- **Rendering**: Is the component receiving the right props/state? (check React DevTools)
- **Events**: Is the handler firing? Is it updating the right state? (add a console.log at the handler)

### Tools
- **React DevTools**: Inspect component state and props, trace re-renders
- **Tanstack Query DevTools**: Inspect cache state, query status, cache keys
- **Browser DevTools (Network tab)**: Verify server responses
- **URL bar**: Verify URL state is correct
- **zustand middleware (devtools)**: Inspect store state and action history

---

## 9. Integration with Melted Peak

### State Architecture in Change Plans
When writing a `active/change_plan.md` that involves state:
- Classify every new piece of state using the five categories
- Justify the chosen management approach
- Note any state that is shared across component boundaries
- Identify cache invalidation points for server state

### Regression Checklist
State changes are a common source of regressions. Add to `active/regression_checklist.md`:
- Components that depend on the changed state
- Cache invalidation flows that may be affected
- URL state params that interact with the change
- Form submission flows that consume the changed state

### Known Issues
Log recurring state problems in `memory/known_issues.md`:
- Stale data after mutations (missing invalidation)
- State synchronization bugs between URL and UI
- Performance issues from unnecessary re-renders
- Race conditions between concurrent updates

---

## Anti-Patterns

- Storing server data in useState (creates synchronization problems)
- Using a global store for everything (over-centralization)
- Storing derived values instead of computing them (state duplication)
- Using Context for frequently changing values without splitting (causes cascading re-renders)
- Putting large objects in the URL (URL has a length limit and is user-visible)
- Skipping server-side validation because the form validates on the client
- Using useEffect to "sync" two pieces of state (usually means one should be derived)
- Creating a new store/context before trying useState + props (premature abstraction)
- Ignoring the dependency array linter (leads to stale closures and subtle bugs)
- Clearing form inputs on validation error (destroys user work)
