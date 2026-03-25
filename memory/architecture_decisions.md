# Architecture Decisions

Records important design decisions using the ADR (Architecture Decision Record) format.

## ADR-001: Adopt Melted Peak as Engineering Context Operating System

- **Date**: 2026-03-25
- **Status**: accepted
- **Context**: Claude Code sessions start from zero. Context is lost between sessions, causing repeated mistakes, forgotten decisions, and regression bugs. A structured system is needed to maintain engineering context across sessions.
- **Decision**: Adopt the Melted Peak system -- a filesystem-based context operating system that Claude Code reads on startup and updates throughout each session. The system uses markdown and YAML files with defined responsibilities and lifecycles.
- **Consequences**:
  - Every session starts with full context from the previous session
  - Engineering discipline is enforced through protocols (change plans, regression prevention, issue isolation)
  - New knowledge is accumulated through frameworks, skills, and knowledge packs
  - Overhead is introduced (maintaining files, following protocols) but is offset by reduced rework and fewer regressions

## ADR-002: Two-Tier Memory Architecture (Hot and Warm)

- **Date**: 2026-03-25
- **Status**: accepted
- **Context**: Some context must be loaded every session (current state), while other context is only relevant sometimes (historical data). Loading everything wastes context window.
- **Decision**: Split memory into hot (active/) and warm (memory/) tiers. Hot memory is read every boot. Warm memory is read selectively by the context compiler.
- **Consequences**:
  - Boot time is fast (only active/ files are mandatory)
  - Historical context is available on demand without cluttering every session
  - The context compiler must be intelligent about when to load warm memory

## ADR-003: Component Normalization Requirement

- **Date**: 2026-03-25
- **Status**: accepted
- **Context**: Raw documentation and guides come in various formats and quality levels. Using them directly creates inconsistency and makes the context compiler's job harder.
- **Decision**: All components (frameworks, skills, knowledge) must be normalized into a standard three-file structure (source, manifest, summary) before use. Raw material goes through incoming/ staging.
- **Consequences**:
  - Consistent structure makes automated context selection possible
  - The manifest's context_cost field enables intelligent loading decisions
  - Ingestion takes effort, but the normalized result is reusable across projects
