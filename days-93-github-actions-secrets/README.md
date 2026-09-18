# Day 93 — GitHub Actions Secrets
## What We Are Studying
We store AWS access keys and an SSH private key as GitHub repository secrets and use them in a workflow via `${{ secrets.NAME }}`. This keeps credentials out of code and logs.
## Commands Used
| Command | Purpose |
|---------|---------|
| `gh secret set NAME --body VALUE` | Create/update a repo secret |
| `gh secret list` | List secret names in repo |
| `${{ secrets.NAME }}` | Use secret in workflow YAML |
