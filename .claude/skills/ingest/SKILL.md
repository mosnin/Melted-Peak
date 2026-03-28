---
name: ingest
description: Begin the ingestion workflow for a new framework, skill, or knowledge pack — validates structure and moves through incoming/ staging
user-invocable: true
---

# /ingest — Component Ingestion

1. Place component in `incoming/[name]/`
2. Validate against readiness gate (`docs/core/11_readiness_gate.md`)
3. Check for required files: source, manifest.yaml, summary.md
4. Verify manifest fields and status
5. If passes: move to skills/, knowledge/, or frameworks/
6. Register in relevant index
7. Update dependency_map.md if needed
