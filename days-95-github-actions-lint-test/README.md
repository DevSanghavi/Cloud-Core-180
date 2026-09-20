# Day 95 — GitHub Actions Lint & Test
## What We Are Studying
We add a lint/test stage in GitHub Actions that runs shellcheck, pytest, or npm test before any build/push steps. This ensures only code that passes checks produces images or artifacts.
## Commands Used
| Command | Purpose |
|---------|---------|
| `shellcheck script.sh` | Lint shell scripts for common mistakes |
| `pytest tests/` | Run Python unit tests |
| `npm test` | Run Node.js test suite |
