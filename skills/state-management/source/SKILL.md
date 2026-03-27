# Skill: State Management

## Purpose
Provide a decision framework for choosing and implementing state management in frontend applications. Classify state by type, select the right tool for each category, and avoid common pitfalls that lead to bugs, stale data, and unmaintainable code.

## Trigger
- Deciding where to store a new piece of state
- Choosing between state management libraries
- Debugging stale data, unnecessary re-renders, or state sync issues
- Reviewing code for state duplication or prop drilling
- Planning the state architecture for a new feature or application

## Workflow

### Step 1: Classify the State

Every piece of state falls into one of these categories. Classifying correctly is the single most important decision -- it determines which tool to use.

| Category | Definition | Examples | Lifespan |
|----------|-----------|----------|----------|
| **Server state** | Data owned by the backend, accessed via API | User profile, product list, order history | Outlives the session |
| **Client state** | UI-only data that never hits the server | Modal open/closed, sidebar collapsed, selected tab | Current session or shorter |
| **URL state** | State encoded in the URL for shareability | Search filters, pagination, selected item ID | Bookmarkable, shareable |
| **Form state** | User input in progress, not yet submitted | Field values, validation errors, touched/dirty flags | Until submit or discard |
| **Derived state** | Computed from other state, never stored independently | Filtered list, total price, "is valid" boolean | Recomputed on dependency change |

**Decision rule**: If it comes from an API, it is server state -- do not copy it into client state. If it can be computed from other state, it is derived -- do not store it separately.

### Step 2: Choose the Right Tool

```
What type of state is it?
|
+-- Server state --> Tanstack Query / SWR / RTK Query
|
+-- Client state
|     |
|     +-- Shared across distant components? --> zustand / Jotai / Redux
|     +-- Shared within a subtree? ----------> React Context
|     +-- Local to one component? -----------> useState / useReducer
|
+-- URL state --> URL search params (nuqs, next/navigation, react-router)
|
+-- Form state --> react-hook-form / Formik (+ zod for validation)
|
+-- Derived state --> Compute inline (useMemo, selectors, getter functions)
```

**Do not reach for a state library by default.** Start with the simplest option that works. Escalate only when you hit a real problem, not a hypothetical one.

### Step 3: Implement Server State

Server state is the most common source of bugs when handled incorrectly. Use a dedicated server-state library.

#### Recommended: Tanstack Query (React Query)

```
Core concepts:
- queryKey: Unique cache key (array). Include all variables that affect the response.
- queryFn: The fetch function. Returns a promise.
- staleTime: How long data is considered fresh (default 0).
- gcTime: How long unused data stays in cache (default 5 min).
```

#### Cache Invalidation Strategies

| Strategy | When to Use | How |
|----------|------------|-----|
| **Invalidate on mutation** | After create/update/delete | `queryClient.invalidateQueries({ queryKey: [...] })` |
| **Optimistic update** | When UX speed matters and rollback is safe | Update cache before mutation, rollback on error |
| **Poll / refetch on focus** | Data changes externally (other users, background jobs) | `refetchInterval`, `refetchOnWindowFocus` |
| **Pessimistic update** | When correctness matters more than speed | Wait for mutation success, then invalidate |

#### Optimistic Updates Pattern

```
1. Cancel in-flight queries for the same key
2. Snapshot the current cache value
3. Optimistically set the new value in cache
4. Execute the mutation
5. On error: roll back to snapshot, show error
6. On settle: invalidate to get server truth
```

**When NOT to use optimistic updates**: financial transactions, irreversible actions, complex multi-entity mutations where rollback state is ambiguous.

#### Common Server State Mistakes

- Copying API data into useState (creates two sources of truth)
- Not setting appropriate staleTime (causes unnecessary refetches or stale UI)
- Using overly broad query keys (cache misses) or overly narrow ones (stale data)
- Forgetting to invalidate related queries after a mutation

### Step 4: Implement Client State

#### Local Component State (useState / useReducer)

**Default choice.** Use for state that belongs to a single component.

Use `useReducer` when:
- State transitions are complex (multiple fields change together)
- Next state depends on previous state in non-trivial ways
- You want to centralize transition logic for testing

#### React Context

Use when state needs to be shared within a subtree and changes infrequently.

| Good For | Bad For |
|----------|---------|
| Theme, locale, auth status | Rapidly changing values (mouse position, animations) |
| Feature flags | Large state objects where consumers only need a slice |
| "Nearest provider" patterns | Anything that triggers frequent re-renders of many consumers |

**Performance rule**: Every context consumer re-renders when the context value changes. If this is a problem, split into multiple contexts or switch to an external store.

#### External Stores (zustand, Jotai, Redux)

Use when state is shared across distant components and/or changes frequently.

| Library | Best For | Mental Model |
|---------|----------|-------------|
| **zustand** | Simple shared state, few stores | Single store with selectors, minimal boilerplate |
| **Jotai** | Many independent atoms of state | Bottom-up atomic state, derived atoms |
| **Redux Toolkit** | Complex state with strict update patterns, large teams | Single store, reducers, middleware for side effects |
| **Signals (Preact/Angular/Solid)** | Fine-grained reactivity without selectors | Reactive primitives, auto-tracking dependencies |

**Selection heuristic**: If you need one or two shared stores with simple logic, use zustand. If you have many independent pieces of state that compose, use Jotai. If your team is large and you need strict patterns and middleware, use Redux Toolkit.

### Step 5: Implement URL State

State that should survive page refresh, be shareable via link, or support browser back/forward belongs in the URL.

#### What Belongs in the URL

- Search queries and filters
- Pagination (page number, page size)
- Sort order
- Selected tab or view mode
- Selected item ID (detail views)

#### What Does NOT Belong in the URL

- Auth tokens or sensitive data
- Transient UI state (modal open, tooltip visible)
- Large data blobs

#### Implementation Pattern

```
1. Define the URL schema (param names, types, defaults)
2. Parse params on mount (validate with zod if complex)
3. Update URL on user interaction (replace for filters, push for navigation)
4. Derive component state from URL params (URL is the source of truth)
```

Use `replace` (not `push`) for filter/sort changes to avoid polluting browser history. Use `push` when the user would expect "back" to undo the action.

### Step 6: Implement Form State

#### Recommended: react-hook-form + zod

```
Why react-hook-form:
- Uncontrolled by default (fewer re-renders)
- Built-in validation integration
- Small bundle size
- Handles complex forms (arrays, nested objects)

Why zod for validation:
- Schema is the single source of truth (share with API validation)
- Type inference (schema -> TypeScript type)
- Composable (extend, merge, pick, omit)
```

#### Controlled vs Uncontrolled

| Approach | When to Use |
|----------|------------|
| **Uncontrolled** (default with react-hook-form) | Most forms. Better performance. |
| **Controlled** | When you need to react to every keystroke: live preview, dependent fields, character counters |

#### Form State Boundaries

- Form state lives inside the form component. Do not lift it into global state.
- On successful submit, the result becomes server state (invalidate relevant queries).
- On error, keep form state intact so the user can correct and retry.

### Step 7: Handle Derived State

Derived state should never be stored. Compute it.

```
Bad:  const [items, setItems] = useState([...]);
      const [filteredItems, setFilteredItems] = useState([...]);
      // Now you must keep filteredItems in sync with items

Good: const [items, setItems] = useState([...]);
      const [filter, setFilter] = useState('');
      const filteredItems = useMemo(
        () => items.filter(item => item.name.includes(filter)),
        [items, filter]
      );
```

**When to memoize derived state**: Only when the computation is expensive. `useMemo` has overhead; for cheap derivations (filtering small arrays, formatting strings), compute inline without memoization.

## Common Pitfalls

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| **State duplication** | Data gets out of sync, UI shows stale values | Identify the single source of truth; derive everything else |
| **Prop drilling** | Props passed through 3+ intermediate components that don't use them | Use Context (if infrequent updates) or an external store (if frequent) |
| **Over-centralization** | All state in one global store; every change re-renders everything | Keep state as local as possible; only lift when needed |
| **Stale closures** | Event handlers or effects capture old state values | Use refs for values that change but shouldn't trigger re-renders; use functional updates (`setState(prev => ...)`) |
| **Sync state between sources** | useEffect to copy server state into local state | Use server state library directly; derive what you need |
| **Missing loading/error states** | UI breaks or shows nothing during fetches | Server state libraries provide these out of the box; always handle all three states (loading, error, success) |
| **URL state drift** | URL and UI get out of sync | Make URL the source of truth; derive UI state from URL, not the other way around |

## State Debugging Approach

When state behaves unexpectedly, follow this sequence:

```
1. Identify the source of truth
   - Where is this state defined?
   - Is there more than one copy? (If yes, that is likely the bug.)

2. Trace the data flow
   - How does data get from source to the component showing the bug?
   - Are there any transformations, memoizations, or selectors in the path?

3. Check the update mechanism
   - What triggers a state change?
   - Is the update referentially stable? (Object/array identity matters in React.)
   - Is a stale closure capturing an old value?

4. Inspect timing
   - Is the state updated before or after the render that reads it?
   - Are there race conditions between multiple async updates?
   - Is a useEffect running at the wrong time in the lifecycle?

5. Verify cache behavior (for server state)
   - Is the query key correct and specific enough?
   - Is staleTime set appropriately?
   - Is cache being invalidated after related mutations?
```

**Tools**: React DevTools (component state), React Query DevTools (cache state), browser URL bar (URL state), Redux DevTools / zustand middleware (store state).
