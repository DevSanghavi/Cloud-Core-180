# Day 167 — Speed Drills: Run common commands (docker ps, terraform plan, git rebase) under time pressure

## Goal

Build speed and accuracy with common Docker, Terraform, and Git commands using a throwaway practice folder. Do not run commands inside P1, P2, or P3 repositories.

## Safety Rules

- Create and use only `~/cloud-practice/speed-drill-practice`.
- Do not run Docker commands against P1 or P2 containers.
- Do not run `terraform plan`, `terraform apply`, or `terraform destroy` in P1, P2, or P3.
- Do not run `git rebase` in P1, P2, P3, or Cloud-Core-180.
- Do not run any AWS create, modify, delete, terminate, or destroy command.
- Use a local Terraform configuration only; no cloud provider, backend, or credentials are required.

## Speed Drill Targets

| Command | Target time | Success condition |
|---|---:|---|
| `docker ps` | Under 5 seconds | Container list appears or safe empty result |
| `docker inspect` | Under 10 seconds | Correct container details appear |
| `terraform fmt` | Under 10 seconds | Files formatted |
| `terraform validate` | Under 15 seconds | Validation succeeds |
| `terraform plan` | Under 30 seconds | Plan completes with no changes |
| `git status` | Under 5 seconds | Repository status appears |
| `git log --oneline -5` | Under 5 seconds | Last five commits appear |
| `git rebase --continue` | Under 10 seconds | Command completes or safely reports no rebase in progress |
| `git rebase --abort` | Under 10 seconds | Command completes or safely reports no rebase in progress |

## Setup

```bash
mkdir -p ~/cloud-practice/speed-drill-practice
cd ~/cloud-practice/speed-drill-practice
git init
```

Expected: a new empty Git repository is created in the throwaway folder.

## Drill 1 — Docker Commands

Run these commands and record the time for each:

```bash
time docker ps
```

Expected: Docker container list appears or a safe empty table appears.

```bash
time docker inspect --format '{{.Name}} {{.State.Status}}' $(docker ps -q | head -n 1)
```

Expected: one running container name and its state appear; if no containers are running, record that result safely.

## Drill 2 — Terraform Commands

Create a minimal local Terraform file:

```bash
cat > main.tf <<'EOF'
resource "local_file" "practice" {
  content  = "Speed drill practice file"
  filename = "${path.module}/practice.txt"
}
EOF
```

Run these commands and record the time for each:

```bash
time terraform fmt
```

Expected: Terraform formatting completes.

```bash
time terraform validate
```

Expected: `Success! The configuration is valid.`

```bash
time terraform plan -input=false
```

Expected: Terraform plans one `local_file` resource; no AWS resources are created or changed.

## Drill 3 — Git Commands

Create a practice commit:

```bash
echo "speed drill" > notes.txt
git add notes.txt
git commit -m "practice: speed drill"
```

Run these commands and record the time for each:

```bash
time git status
```

Expected: clean working tree after the commit.

```bash
time git log --oneline -5
```

Expected: the practice commit appears.

```bash
time git rebase --continue
```

Expected: either the command completes or Git safely reports that no rebase is in progress.

```bash
time git rebase --abort
```

Expected: either the command completes or Git safely reports that no rebase is in progress.

## Timing Log

| Drill | Command | Target time | Actual time | Pass/Fail |
|---|---|---:|---:|---|
| Docker | `docker ps` | Under 5 seconds |  |  |
| Docker | `docker inspect` | Under 10 seconds |  |  |
| Terraform | `terraform fmt` | Under 10 seconds |  |  |
| Terraform | `terraform validate` | Under 15 seconds |  |  |
| Terraform | `terraform plan` | Under 30 seconds |  |  |
| Git | `git status` | Under 5 seconds |  |  |
| Git | `git log --oneline -5` | Under 5 seconds |  |  |
| Git | `git rebase --continue` | Under 10 seconds |  |  |
| Git | `git rebase --abort` | Under 10 seconds |  |  |

## Rebase Understanding

`git rebase` moves or replays commits onto another base commit. Use it to keep a feature branch history clean, but never rebase shared or pushed main-branch history without team agreement.

- `git rebase main`: replay the current branch commits onto the latest `main`.
- `git rebase --continue`: continue after resolving a rebase conflict.
- `git rebase --abort`: stop the rebase and return to the pre-rebase state.
- `git rebase -i HEAD~3`: interactively edit the last three commits.

## Rules Followed

- No P1, P2, P3, or Cloud-Core-180 repository was modified during the drills.
- No AWS resource was created, modified, deleted, terminated, or destroyed.
- Terraform used only a local file resource and no cloud provider.
- All rebase commands were run only in the throwaway practice repository.
