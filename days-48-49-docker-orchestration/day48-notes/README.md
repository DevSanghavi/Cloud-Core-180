# Day 48: Docker Storage — Volumes vs Bind Mounts

## Topic Overview
We explored how to decouple data from the container lifecycle. Containers are temporary by design; if data is written inside their default file system layer, it vanishes completely when the container is stopped or updated. To solve this, we use production-ready Volumes and development-friendly Bind Mounts.

## What We Did & How We Did It
1. **Created a Managed Volume**: We built a standalone storage box managed by the Docker engine.
2. **Tested Persistence**: We spun up a temporary container, wrote files into the volume, destroyed the container completely, and then read the data back safely using a brand-new container.
3. **Accumulated Application Logs**: We packaged a custom application script that appends execution logs with metadata to our persistent storage volume on every run.
4. **Verified Live Code Mounting**: We bridged our local host machine workspace directory directly into a container to view local text files live without rebuilding images.

## Key Principles
* **Use volumes for production state**
* **Use bind mounts for local development.**

## Exact Commands Used

### Setup and Volume Creation
```bash
# Create the isolated persistent volume
docker volume create day48-practice-vol

# Inspect the engine parameters and volume storage location
docker volume inspect day48-practice-vol
```

### Destruction & Persistence Testing
```bash
# Write 2 test files into the volume path
docker run --name day48-temp-worker -v day48-practice-vol:/data alpine:3.20 sh -c 'echo "Practice File One" > /data/file1.txt && echo "Practice File Two" > /data/file2.txt'

# Completely destroy the container layer
docker rm day48-temp-worker

# Read the files using a brand new independent container
docker run --rm -v day48-practice-vol:/data alpine:3.20 sh -c 'cat /data/file1.txt && cat /data/file2.txt'
```

### Custom Application Build & Execution
```bash
# Build the production-ready stateful tracker image
docker build -t dev-day48-notes:0.1.0 .

# Execute runs to accumulate state logs without losing previous timestamps
docker run --rm -v day48-practice-vol:/data dev-day48-notes:0.1.0
```

### Local Workspace Bind Mount Testing
```bash
# Directly link the current working directory path to the container filesystem
docker run --rm --mount type=bind,src=\$(pwd),dst=/shared alpine:3.20 cat /shared/host.txt
```
