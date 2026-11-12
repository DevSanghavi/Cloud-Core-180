# Day 149/180 — Phase 7, Day 4: Git Scenarios

## Scenario 1 — Merge conflicts

### Symptom
Git stops a merge, rebase, or pull and reports `CONFLICT (content): Merge conflict in FILE`. The repository is left in a conflicted state until the conflicts are resolved.

### Likely causes
1. Two branches changed the same lines in the same file.
2. A file was deleted on one branch and modified on another.
3. A rebase replayed commits onto a branch with competing changes.
4. Generated files, lock files, or configuration files were edited on both branches.
5. The merge was started before the working tree was clean.

### Triage
Run from the affected repository.

```bash
git status
```

Meaning: shows whether a merge or rebase is in progress and lists files with conflicts.

```bash
git diff --name-only --diff-filter=U
```

Meaning: lists only the files that still contain unresolved conflicts.

```bash
git diff
```

Meaning: shows the conflicting changes in the working tree.

```bash
git log --oneline --graph --decorate --all -n 20
```

Meaning: shows recent branch history and helps identify which branches diverged.

```bash
git branch --show-current
```

Meaning: confirms the current branch before resolving or aborting anything.

### Fix
1. Confirm the current branch and ensure no unrelated changes are staged.
2. Open each conflicted file and resolve the markers:
   - `<<<<<<< HEAD` contains the current branch version.
   - `=======` separates the two versions.
   - `>>>>>>> branch-name` contains the incoming branch version.
3. Keep the correct code, remove all conflict markers, and preserve required changes from both sides when appropriate.
4. Run the project’s tests or validation commands before committing.
5. Stage resolved files with `git add FILE`.
6. Complete the merge with `git commit` or continue an interrupted rebase with `git rebase --continue`.
7. Verify the final result with `git status` and `git log --oneline -n 5`.

### Prevention
- Pull or rebase frequently to keep feature branches close to the target branch.
- Keep changes small and focused.
- Avoid editing generated files directly.
- Agree on ownership of shared configuration and lock files.
- Run tests before merging.

### Real incident
I once ran Git commands from the wrong folder because I had three separate repositories under `~/cloud-practice/`. This taught me to always confirm the repository and branch with `git branch --show-current` and `git status` before resolving conflicts or changing history.

### 30-second interview answer
“When I get a merge conflict, I first run `git status` to understand whether I am in a merge or rebase and which files conflict. I inspect each conflict, keep the correct changes, remove the conflict markers, and test the result before staging and completing the merge. I never blindly choose one side without understanding why the change was made.”

## Scenario 2 — Detached HEAD recovery

### Symptom
Git displays `You are in 'detached HEAD' state`, and new commits may not belong to any branch. This commonly happens after checking out a commit, tag, or remote branch directly.

### Likely causes
1. A commit hash, tag, or remote branch was checked out directly.
2. A rebase or interactive rebase left the repository in a detached state.
3. A branch was deleted while its commits were still checked out.
4. The developer intended to create a new branch but only checked out a commit.

### Triage
Run from the affected repository.

```bash
git status
```

Meaning: confirms detached HEAD state and shows the current commit.

```bash
git branch --show-current
```

Meaning: returns no branch name when HEAD is detached.

```bash
git log --oneline -n 10
```

Meaning: shows the commits reachable from the current detached HEAD.

```bash
git reflog
```

Meaning: shows recent HEAD movements and is the main recovery tool for finding a commit that is no longer on a branch.

```bash
git branch -a
```

Meaning: lists local and remote branches to identify the intended branch.

### Fix
1. If the detached commit is only for inspection, return safely with `git switch main` or the intended branch name.
2. If work was done while detached, create a branch at the current commit with `git switch -c recovery-branch`.
3. Use `git reflog` to locate the intended commit if the working state has changed.
4. Merge or cherry-pick the recovered commits into the correct branch through a reviewed pull request.
5. Delete the temporary recovery branch only after confirming that its commits are safely merged or no longer needed.
6. Verify the final branch state with `git status`, `git log --oneline -n 5`, and `git branch --show-current`.

### Prevention
- Check `git status` before starting work.
- Create a feature branch before inspecting older commits.
- Use `git switch` rather than manually moving HEAD when possible.
- Treat `git reflog` as a recovery tool, not a replacement for clear branching.

### Real incident
Because I maintain separate repositories for Cloud-Core-180, terraform-aws-infra, gitops-cicd-pipeline, and devops-monitoring-suite, I learned to verify the current repository and branch before running Git commands. A detached HEAD is manageable, but working in the wrong repository can create confusion that looks like lost work.

### 30-second interview answer
“When I am in detached HEAD, I first check `git status` and `git reflog`. If I made changes, I create a recovery branch immediately with `git switch -c recovery-branch`, then merge or cherry-pick those commits into the correct branch. If I was only inspecting a commit, I return to the intended branch. I never assume commits are lost until I have checked the reflog.”

## Scenario 3 — Reverting bad commits

### Symptom
A commit introduced a bug, broke a deployment, or contains an unwanted change, and the team needs to undo its effect safely.

### Likely causes
1. A feature commit introduced a regression.
2. A configuration or dependency change broke the build.
3. A deployment used an incorrect image, secret, or environment value.
4. A commit was pushed to a shared branch and must not be rewritten.
5. Multiple commits need to be undone in the correct order.

### Triage
Run from the affected repository.

```bash
git status
```

Meaning: confirms that the working tree is clean before changing history or creating a revert commit.

```bash
git log --oneline -n 10
```

Meaning: identifies the commit or commits that introduced the problem.

```bash
git show COMMIT_HASH --stat
```

Meaning: shows which files the suspect commit changed.

```bash
git show COMMIT_HASH
```

Meaning: shows the exact code, configuration, or dependency change introduced by the commit.

```bash
git branch --show-current
```

Meaning: confirms that the revert will happen on the intended branch.

### Fix
1. Confirm the bad commit hash and review its diff before changing anything.
2. For a single pushed commit, create a reverse commit with `git revert COMMIT_HASH`.
3. For multiple consecutive commits, revert them in reverse order or use `git revert OLDEST_HASH^..NEWEST_HASH` after confirming the range.
4. Resolve any revert conflicts using the same review process as a merge conflict.
5. Run tests and validate the deployment configuration before pushing.
6. Push the revert through the normal branch and pull-request workflow.
7. If a deployment must recover immediately, use the established rollback workflow and deploy the last known-good image digest or configuration.

### Prevention
- Require peer review and CI checks before merging.
- Keep commits small and descriptive.
- Tag or record the last known-good deployment digest.
- Never force-push shared branches without team approval.
- Use feature flags or staged rollouts for risky changes.

### Real incident
One of my deployment workflows failed after a Terraform-related issue involving a missing database password secret and a local AWS profile in the backend configuration. The lesson was to validate secrets, backend configuration, and runner dependencies before treating a deployment failure as an application-code problem.

### 30-second interview answer
“When a bad commit reaches a shared branch, I use `git revert` rather than rewriting history. I first inspect the commit with `git show`, create a reverse commit, resolve any conflicts, test the result, and push through the normal review workflow. If production is broken, I use the established rollback process and last known-good image digest while the permanent fix is prepared.”

## Interview Rule

For Git incidents, protect shared history first: **inspect the current state, recover work with branches and reflog, use revert for shared commits, and avoid force-pushing or rewriting history without approval.**
