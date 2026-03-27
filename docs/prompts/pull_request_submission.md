# Pull Request Submission Prompt

Use when ready to submit changes as a PR.

---

## Prompt

```
Prepare and submit a pull request:

1. Read active/change_plan.md -- what was planned and executed?
2. Read memory/recent_deltas.md -- what files were changed?
3. Run the code-review skill (self-review) on all changed files
4. Check active/regression_checklist.md -- all affected areas verified?
5. Verify active/validation_plan.md results are all passing

Then create the PR:
- Title: concise description of what this PR does
- Body: What (summary), Why (problem/context), How (approach), Testing (verification)
- Include checklist: change plan followed, regressions checked, self-reviewed
- Reference the active issue if applicable

After PR is created:
- Update memory/progress_log.md
- Update memory/change_log.md
- Update active/active_context.md with PR link
```

## When to Use
- After completing a change plan
- When code is ready for review/merge
- Before ending a session with uncommitted work
