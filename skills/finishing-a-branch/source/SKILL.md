# Skill: Finishing a Branch

## Purpose

Structured decision workflow for what to do when development on a branch is complete -- merge, PR, keep, or discard. Prevents premature merges, lost work, and cleanup gaps.

## Trigger

- All tasks in the change plan are marked complete
- Tests pass and code review is done
- Branch is ready for a final decision
- User asks "what now?" after finishing work on a branch

## Workflow

### Step 1: Pre-Completion Checklist

Before making any decision about the branch, verify ALL of these:

| Check | How to Verify |
|-------|---------------|
| All tests pass | Run the full test suite NOW. Read the output. |
| No uncommitted changes | Run `git status` -- working tree must be clean |
| Change plan complete | Review `active/change_plan.md` -- all steps done |
| Regression checklist reviewed | Walk through `active/regression_checklist.md` |
| Validation plan passes | Run `active/validation_plan.md` checks |
| No TODO/FIXME left behind | Search changed files for unresolved markers |

If ANY check fails, stop here. Fix it before proceeding.

### Step 2: Decision Tree

Choose ONE path:

#### Option A: Merge Directly

**When**: Small changes, solo work, no review required, main branch is the target.

```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Merge the branch
git merge [branch-name]

# Verify tests still pass after merge
# RUN THE TESTS -- do not skip this

# Push
git push origin main

# Delete the branch
git branch -d [branch-name]
git push origin --delete [branch-name]
```

**Verify after**: tests pass on main, no merge artifacts, deployment pipeline green.

#### Option B: Create a Pull Request

**When**: Team project, changes need review, documentation of decisions matters.

```bash
# Rebase on latest target branch
git fetch origin
git rebase origin/main

# Force-push ONLY your feature branch (never shared branches)
git push origin [branch-name] --force-with-lease

# Create PR (use git-workflow skill's PR template)
```

**Verify after**: PR description is complete, CI passes, reviewers assigned.

#### Option C: Keep Branch (Park for Later)

**When**: Work is complete but not ready to merge (blocked, waiting on dependency, future release).

```bash
# Push latest state
git push origin [branch-name]

# Document why the branch is being kept
# Add entry to memory/known_issues.md or memory/progress_log.md
```

**Verify after**: branch is pushed to remote, reason is documented, no local-only state.

#### Option D: Discard Branch

**When**: Work is abandoned, approach was wrong, superseded by another branch.

```bash
# FIRST: confirm no uncommitted changes
git status
git stash list

# SECOND: confirm nothing valuable is local-only
git log origin/main..[branch-name] --oneline
# Review each commit -- is anything worth keeping?

# Switch away from the branch
git checkout main

# Delete local
git branch -D [branch-name]

# Delete remote (if pushed)
git push origin --delete [branch-name]
```

**Verify after**: branch is gone from local and remote, no lost work.

### Step 3: Worktree Cleanup (If Applicable)

If the branch was in a git worktree:

```bash
# Remove the worktree
git worktree remove [worktree-path]

# Prune stale worktree references
git worktree prune

# Then proceed with branch deletion as above
```

### Step 4: Post-Completion Updates

After the branch decision is executed:

1. **Update `active/active_context.md`** -- clear the branch work, note what was merged/discarded
2. **Update `memory/progress_log.md`** -- record the completion and outcome
3. **Close `active/active_issue.md`** -- if the branch resolved the active issue, reset it to stub
4. **Update `memory/change_log.md`** -- log the merge/discard with context
5. **Clear `active/change_plan.md`** -- reset to stub if plan is fully executed

## Red Flags -- Stop and Verify

- **Never merge without running tests** -- "they passed earlier" is not evidence
- **Never force-push shared branches** -- only force-push YOUR feature branch with `--force-with-lease`
- **Never delete branches with uncommitted work** -- run `git status` and `git stash list` first
- **Never skip the post-completion updates** -- future sessions depend on accurate state
- **Never merge with unresolved TODO/FIXME markers** -- they become permanent debt

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Tests passed earlier" | Run them again. Code may have changed since then. |
| "Small change, skip the PR" | PRs document decisions for future reference. Small PRs are fast to review. |
| "I'll clean up the branch later" | You won't. Delete it now or document why it stays. |
| "Force-push is fine, nobody else is on this branch" | Use `--force-with-lease` anyway. It costs nothing and prevents accidents. |
| "The worktree is fine to leave" | Stale worktrees cause confusion. Clean up now. |
| "I'll update the context files later" | The next session starts by reading those files. Update them now. |
| "No need to check for uncommitted work, I committed everything" | `git status` takes one second. Run it. |
| "Regression checklist is overkill for this change" | The checklist exists because someone thought the same thing before a bug shipped. |

## Integration

- **Pairs with**: `git-workflow` -- branch naming, commit discipline, PR template
- **Pairs with**: `verification-before-completion` -- the iron law applies here too
- **Pairs with**: `subagent-driven-development` -- after subagents complete tasks, this skill closes the loop
- **Relates to**: `active/change_plan.md` -- must be complete before finishing
- **Relates to**: `active/regression_checklist.md` -- must be reviewed before merging
