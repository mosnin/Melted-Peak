---
name: audit
description: Run the Melted Peak self-audit — checks registry integrity, file structure, cross-references, and active state health
user-invocable: true
---

# /audit — System Self-Audit

Launch the `melted-peak-auditor` subagent to run 8 integrity checks:

1. Registry completeness — every skill in skill_index.yaml has 3 files
2. Manifest validity — all manifests have required fields
3. Status gate — no draft/deprecated in active registry
4. Cross-references — no broken references
5. Active state health — active files properly filled or stub
6. Memory continuity — handoff and progress log current
7. Peak integrity — mounted peaks have valid peak.yaml
8. Context compiler profiles — all referenced components exist

Report findings with severity (critical/warning/info).
