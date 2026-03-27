# Debugging Techniques Reference

Systematic techniques for finding and fixing bugs, organized by approach.

## Technique 1: Binary Search (Bisection)

**When to use**: You know it worked before, and now it doesn't.

```
1. Find a known-good state (commit, version, configuration)
2. Find the known-bad state (current)
3. Test the midpoint
4. If midpoint is good → bug is in second half
5. If midpoint is bad → bug is in first half
6. Repeat until you find the exact change
```

Git bisect automates this for commits: `git bisect start`, `git bisect good <hash>`, `git bisect bad`.

## Technique 2: Rubber Duck Debugging

**When to use**: You're stuck and can't see the issue.

Explain the code out loud (or in writing) line by line:
- What does this line do?
- What state does it expect?
- What state does it actually have?
- Where does the expectation diverge from reality?

The act of explaining often reveals the assumption you didn't know you were making.

## Technique 3: Minimial Reproduction

**When to use**: Bug is in complex code with many moving parts.

```
1. Start with the broken system
2. Remove components one at a time
3. After each removal, test: does the bug still occur?
4. When removing something fixes the bug → that's the culprit area
5. Add things back one at a time to find the exact interaction
```

## Technique 4: Trace the Data

**When to use**: Output is wrong but you don't know where it goes wrong.

```
1. Identify the input
2. Trace it through every transformation step
3. At each step: what's the expected value? What's the actual value?
4. The first divergence is where the bug is
```

This works for:
- API request → middleware → handler → database → response
- User input → validation → state update → render
- Event → handler → side effect → state change

## Technique 5: Hypothesis Testing

**When to use**: You have a theory about the cause.

```
1. State the hypothesis clearly ("The bug is caused by X")
2. Predict what you'd see if the hypothesis is correct
3. Test the prediction (don't test the fix -- test the diagnosis)
4. If prediction matches → hypothesis confirmed, proceed to fix
5. If prediction doesn't match → hypothesis wrong, form new one
```

Critical: test the DIAGNOSIS before implementing a FIX. A fix based on a wrong diagnosis wastes time.

## Technique 6: Diff Debugging

**When to use**: It works in one context but not another.

```
Compare the working vs non-working environment:
- Different versions? (git diff)
- Different config? (env vars, feature flags)
- Different data? (edge case in production data)
- Different timing? (concurrency, race conditions)
- Different platform? (browser, OS, Node version)
```

The difference between working and non-working is where the bug lives.

## Technique 7: Print/Log Debugging

**When to use**: You need to understand execution flow or state at runtime.

Rules:
- Add logging at decision points (if/else branches, loop entries, function entries)
- Log both the value AND the context ("userId at auth check: 123")
- Remove debug logging after the bug is found
- For production: use structured logging, not console.log

## When Each Technique Is Best

| Situation | Best Technique |
|-----------|---------------|
| "It used to work" | Binary search |
| "I don't understand this code" | Rubber duck |
| "Too many things interacting" | Minimal reproduction |
| "Output is wrong" | Trace the data |
| "I think I know the cause" | Hypothesis testing |
| "Works here but not there" | Diff debugging |
| "What's the state at this point?" | Print/log debugging |
