# Parallel Work Protocol

Defines how to safely parallelize work using sub-agents while maintaining context integrity and preventing conflicts.

---

## When to Parallelize

Parallelize when:
- Multiple independent files need similar work (e.g., creating several skills)
- Research tasks that don't depend on each other
- Audit checks that examine different parts of the system
- Phase 9 feature builds in Modaf (see subagent dispatch docs)

Do NOT parallelize when:
- Tasks share files (write conflicts)
- Task B depends on Task A's output
- Both tasks modify the same registry or index file
- The order of execution matters for correctness

## Sub-Agent Guidelines

### What Each Agent Must Know
Provide every sub-agent with:
1. The specific task (what to create/check/research)
2. The file paths to work with (avoid conflicts)
3. The conventions to follow (naming, format, structure)
4. What NOT to touch (shared files like registries)

### What the Parent Agent Handles
The parent (orchestrating) agent is responsible for:
1. Dividing work into non-overlapping tasks
2. Providing each agent with complete instructions
3. Merging results after all agents complete
4. Updating shared resources (registries, indexes) after merge
5. Resolving any conflicts between agent outputs

### File Ownership Rules

```
Each sub-agent OWNS its assigned files (read + write)
Each sub-agent may READ any file
Each sub-agent must NOT WRITE to files owned by other agents
Shared files (registries, active/) are updated only by the parent after merge
```

### Pattern: Skill Creation in Parallel

When creating multiple skills simultaneously:
1. Parent creates all directories
2. Each agent writes its own skill's 3 files (SKILL.md, manifest.yaml, summary.md)
3. Parent waits for all agents to complete
4. Parent updates `docs/registry/skill_index.yaml` with all new entries
5. Parent updates `docs/core/99_protocol_cheatsheet.md` if needed
6. Parent commits all changes in a single commit

### Pattern: Audit in Parallel

When running audit checks simultaneously:
1. Each agent runs one audit check (registry, references, dependencies, etc.)
2. Each agent reports findings (does not fix anything)
3. Parent collects all findings
4. Parent applies fixes in a coordinated way
5. Parent logs audit results to `memory/metrics/audit_log.md`

## Conflict Resolution

If two agents accidentally modified the same file:
1. Read both versions
2. Determine which changes are compatible (can be merged)
3. If incompatible: keep the more complete/correct version, re-apply the other's changes manually
4. Log the conflict in `memory/recent_deltas.md`

## Context Window Management

Each sub-agent starts with a fresh context window. To maximize efficiency:
- Give agents self-contained instructions (don't make them read 10 files to understand the task)
- Include key conventions inline rather than referencing protocol files
- Keep agent prompts focused -- one clear task per agent
- Use background agents for tasks where you don't need results immediately
