# Finishing a Branch -- Summary

Structured decision workflow for what to do when branch work is complete. Walks through a pre-completion checklist (tests, clean tree, change plan done), then a decision tree for merge, PR, keep, or discard -- with exact commands, verification steps, and cleanup for each path.

## When to Use
- All tasks on a branch are done and tests pass
- Ready to merge, open a PR, or decide the branch's fate
- Cleaning up after completed or abandoned work

## Key Steps
1. Pre-completion checklist: tests pass, no uncommitted changes, change plan done, regression checklist reviewed
2. Decision tree: merge directly | create PR | keep branch | discard branch
3. Worktree cleanup if applicable
4. Post-completion: update active_context, progress_log, close active_issue

## Context Cost
Small -- decision guide with commands, no heavy reference material.
