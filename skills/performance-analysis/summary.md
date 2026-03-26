# Performance Analysis -- Summary

Systematic performance investigation: define the problem with numbers, profile to find bottlenecks, fix one at a time, measure after, prevent regressions.

## When to Use
- User reports slow performance
- Pre-launch performance audit
- After changes to hot paths

## Key Steps
1. **Define**: What's slow, how slow (numbers), set target
2. **Investigate**: Profile by layer (network, DB, server, client, cache), find the bottleneck
3. **Fix**: One optimization at a time, measure before/after
4. **Prevent**: Add to regression checklist, consider performance budgets

## Critical Rule
Measure, don't guess. Profile first. One optimization at a time.

## Context Cost
Small -- workflow guide with reference tables.
