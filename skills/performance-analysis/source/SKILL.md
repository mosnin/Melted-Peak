# Skill: Performance Analysis

## Purpose
Systematic performance investigation workflow: identify bottlenecks, measure before/after, and prevent performance regressions.

## Trigger
- User reports slow performance
- Performance requirements defined in PRD/constraints
- Pre-launch performance audit
- After significant code changes to hot paths

## Workflow

### Phase 1: Define the Problem

1. **What is slow?** Be specific:
   - Which page/endpoint/operation?
   - How slow? (measure, don't guess)
   - Under what conditions? (load, data volume, device)

2. **Set a target**:
   - What would "fast enough" look like?
   - Use concrete numbers: "< 200ms response time" not "faster"
   - Reference industry benchmarks if applicable:

   | Metric | Good | Acceptable | Poor |
   |--------|------|-----------|------|
   | Page load (LCP) | < 2.5s | < 4s | > 4s |
   | Interaction (INP) | < 200ms | < 500ms | > 500ms |
   | API response | < 200ms | < 1s | > 1s |
   | Database query | < 50ms | < 200ms | > 200ms |

3. **Establish baseline**:
   - Measure current performance with specific numbers
   - Record measurement conditions (data volume, concurrency, hardware)
   - Write baseline to `active/active_issue.md`

### Phase 2: Investigate

4. **Profile, don't guess**:
   - Where is time actually being spent?
   - Common bottleneck locations:

   | Layer | Common Issues | How to Check |
   |-------|-------------|-------------|
   | **Network** | Too many requests, large payloads, no compression | Browser DevTools Network tab |
   | **Database** | N+1 queries, missing indexes, full table scans | Query logging, EXPLAIN |
   | **Server** | Blocking operations, memory leaks, CPU-bound work | Profiler, APM |
   | **Client** | Large bundles, layout thrashing, unnecessary re-renders | Lighthouse, React DevTools |
   | **Caching** | No caching, wrong cache strategy, cache misses | Cache hit rate analysis |

5. **Identify the bottleneck** (singular):
   - The slowest part of the chain determines overall speed
   - Fix the biggest bottleneck first (Amdahl's Law)
   - Don't optimize things that aren't slow

### Phase 3: Fix

6. **Write a change plan** targeting the bottleneck:
   - What specific optimization?
   - What's the expected improvement?
   - What could go wrong? (correctness risk)

7. **Common optimizations by layer**:

   | Bottleneck | Optimization | Risk |
   |-----------|-------------|------|
   | Database N+1 | Eager loading / joins | Over-fetching |
   | Missing index | Add targeted index | Write slowdown |
   | Large payloads | Pagination, compression, field selection | Complexity |
   | No caching | Add cache layer (Redis, in-memory, HTTP) | Stale data |
   | Large bundle | Code splitting, lazy loading, tree shaking | Load order bugs |
   | Re-renders | Memoization, state restructuring | Stale UI |
   | Sync I/O | Async / parallel execution | Error handling complexity |

8. **Measure after**:
   - Same measurement conditions as baseline
   - Compare: did the target get hit?
   - If not, repeat from Phase 2 (next bottleneck)

### Phase 4: Prevent Regressions

9. **Add to regression checklist**:
   - What was the performance-sensitive area?
   - How to verify performance is still acceptable?
   - What patterns to avoid in this code?

10. **Consider performance budgets**:
    - Bundle size budget (e.g., < 200KB initial JS)
    - API response time budget (e.g., p95 < 500ms)
    - Database query budget (e.g., no query > 100ms)
    - If budgets exist, add checks to CI

## Critical Rules

- **Measure, don't guess.** Intuition about performance is usually wrong.
- **Profile first.** Don't optimize based on code reading -- profile to find actual bottlenecks.
- **One optimization at a time.** Multiple changes make it impossible to attribute improvement.
- **Verify the fix worked.** Re-measure with the same methodology as baseline.
- **Don't sacrifice correctness for speed.** A fast wrong answer is worse than a slow right one.

## Anti-Patterns

- Premature optimization (optimizing before measuring)
- Micro-optimizations that don't affect the bottleneck
- Caching without invalidation strategy
- "It feels faster" without measurements
- Optimizing development builds instead of production
