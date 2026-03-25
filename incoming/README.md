# Incoming -- Component Staging Area

This directory is a temporary holding area for raw materials that will become frameworks, skills, or knowledge packs.

## Rules

1. **Nothing here may be used in active work.** Components must pass through normalization and the readiness gate first.
2. Place raw files here (docs, guides, code snippets, references).
3. Run `/ingest` to begin the normalization workflow.
4. The system will create the required three files (source, manifest, summary).
5. Once normalized and verified, the component moves to its destination (`frameworks/`, `skills/`, or `knowledge/`).
6. Raw files are cleaned up after promotion.

## Workflow Reference

See `docs/core/10_ingestion_and_normalization_rules.md` for the full ingestion protocol.
See `docs/core/11_readiness_gate.md` for the readiness criteria.
