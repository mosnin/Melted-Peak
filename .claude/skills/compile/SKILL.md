---
name: compile
description: Run the context compiler for the current task — selects minimal relevant context files based on work type
user-invocable: true
---

# /compile — Context Compiler

Run `docs/core/02_context_compiler.md`:

1. Identify work type (bug-fix, new-feature, refactor, investigation, etc.)
2. Select relevant context profile
3. Load only components listed in that profile
4. Check active peaks for profile extensions
5. Report what was loaded and why
