# Docker Image Management Scripts

This repository contains two shell scripts to help manage Docker images in your Docker Hub repository:

1. `cleanup.sh`: Removes old Docker images while keeping the latest ones.
2. `list_docker_images.sh`: Lists Docker tags from Docker Hub and local images.

## Prerequisites

- Bash shell
- Docker CLI
- `curl` and `jq` installed on your system

## Setup

1. Clone this repository or download the scripts.
2. Make the scripts executable:
   ```
   chmod +x cleanup.sh list_docker_images.sh
   ```

## Usage

1. Set up environment variables:
   ```bash
   export DOCKER_USERNAME="myusername"
   export DOCKER_PASSWORD="mypassword"
   export DOCKER_REPOSITORY="myapp"
   export DOCKER_TAG_PREFIX="v"
   ```

2. List Docker images:
   ```bash
   ./list_docker_images.sh
   ```
   This will show all tags starting with "v" in the "myusername/myapp" repository.

3. Clean up old images:
   ```bash
   ./cleanup.sh
   ```
   This will keep the 3 most recent "v" tagged images and remove older ones.

## Notes

- The `DOCKER_TAG_PREFIX` is optional. If not set, all tags will be considered.
- Ensure your Docker Hub credentials are correct and have the necessary permissions.
- Be cautious when running the cleanup script, as it will remove Docker images from your local system.
- These scripts do not modify anything in your Docker Hub repository; they only affect your local Docker images.

