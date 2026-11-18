# Day 169 — Backup: Save all code, notes, and screenshots to a personal drive

## Goal

Create a safe local backup archive containing project code, daily notes, and screenshots, then upload it manually to a personal drive without including secrets or credentials.

## Backup Scope

| Item | Location | Included | Reason |
|---|---|---|---|
| Cloud-Core-180 notes | `~/cloud-practice/Cloud-Core-180` | Yes | Daily learning record and evidence |
| P1 code | `~/cloud-practice/terraform-aws-infra` | Yes | Terraform AWS infrastructure project |
| P2 code | `~/cloud-practice/gitops-cicd-pipeline` | Yes | GitOps CI/CD pipeline project |
| P3 code | `~/cloud-practice/devops-monitoring-suite` | Yes | Monitoring and backup automation project |
| Screenshots | `~/cloud-practice/screenshots` | Yes if present | Final-run and project evidence |
| `.env` files | All repositories | No | Contains credentials and environment values |
| SSH keys | `~/.ssh` | No | Private authentication material |
| AWS credentials | `~/.aws` | No | Cloud access credentials |
| Terraform state and lock files | All repositories | No | May contain sensitive provider and state data |
| Node modules | P2 | No | Re-creatable dependencies |
| Git internals | All repositories | No | Repositories remain available on GitHub |

## Backup Commands

Run from the home directory:

```bash
cd ~
```

Create a backup directory with today's date:

```bash
mkdir -p ~/cloud-practice-backups
```

Create the backup archive while excluding secrets, credentials, Terraform state, dependency folders, and Git internals:

```bash
tar --exclude='*/.env' --exclude='*/.env.*' --exclude='*/.aws' --exclude='*/.ssh' --exclude='*/terraform.tfstate' --exclude='*/terraform.tfstate.*' --exclude='*/.terraform' --exclude='*/node_modules' --exclude='*/.git' -czvf ~/cloud-practice-backups/cloud-practice-backup-2026-11-18.tar.gz cloud-practice/Cloud-Core-180 cloud-practice/terraform-aws-infra cloud-practice/gitops-cicd-pipeline cloud-practice/devops-monitoring-suite cloud-practice/screenshots
```

Expected: a compressed archive is created at `~/cloud-practice-backups/cloud-practice-backup-2026-11-18.tar.gz`; a missing screenshots folder does not stop the backup.

## Verify the Backup

Check that the archive exists and view its size:

```bash
ls -lh ~/cloud-practice-backups/cloud-practice-backup-2026-11-18.tar.gz
```

Expected: the archive exists with a non-zero size.

Check the archive contents without extracting it:

```bash
tar -tzf ~/cloud-practice-backups/cloud-practice-backup-2026-11-18.tar.gz | head -n 20
```

Expected: project and notes files appear; no `.env`, `.aws`, `.ssh`, Terraform state, or `node_modules` paths appear.

Search the archive listing for excluded sensitive files:

```bash
tar -tzf ~/cloud-practice-backups/cloud-practice-backup-2026-11-18.tar.gz | grep -E '\.env$|\.env\.|\.aws/|\.ssh/|terraform\.tfstate|node_modules/' || true
```

Expected: no output, confirming excluded sensitive and re-creatable files are not included.

## Upload to Personal Drive

Dev uploads the archive manually to a personal drive such as Google Drive, OneDrive, or another private storage location.

Before uploading:

1. Confirm the archive filename includes the backup date.
2. Confirm the archive size is non-zero.
3. Confirm no `.env`, `.aws`, `.ssh`, Terraform state, or `node_modules` paths appear in the archive listing.
4. Upload the archive to a private folder, not a public share.
5. After upload, verify the file appears in the personal drive and download it once to confirm it is readable.

## Backup Record

| Check | Command or action | Expected result | Status |
|---|---|---|---|
| Archive created | `ls -lh` | Non-zero archive size | Yes/No |
| Archive contents | `tar -tzf ... | head -n 20` | Project files listed | Yes/No |
| Secrets excluded | `tar -tzf ... | grep ...` | No sensitive paths | Yes/No |
| Uploaded | Personal drive | Archive visible in private folder | Yes/No |
| Download verified | Personal drive | Archive downloads and opens | Yes/No |

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy command was used.
- P1, P2, P3, and Cloud-Core-180 repositories were not modified or pushed from this exercise.
- No `.env`, AWS credentials, SSH keys, Terraform state, or `node_modules` files were included in the archive.
- The backup was uploaded manually by Dev to a private personal drive.
