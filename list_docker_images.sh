#!/bin/bash

USERNAME="${DOCKER_USERNAME:-}"
PASSWORD="${DOCKER_PASSWORD:-}"
REPOSITORY="${DOCKER_REPOSITORY:-}"
TAG_PREFIX="${DOCKER_TAG_PREFIX:-}"

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$REPOSITORY" ]; then
    echo "Error: DOCKER_USERNAME, DOCKER_PASSWORD, and DOCKER_REPOSITORY must be set."
    exit 1
fi

TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${USERNAME}'", "password": "'${PASSWORD}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)

TAGS=$(curl -s -H "Authorization: JWT ${TOKEN}" "https://hub.docker.com/v2/repositories/${USERNAME}/${REPOSITORY}/tags/?page_size=200&ordering=-last_updated" | jq -r '.results[].name')

TAGS_ARRAY=($(echo "$TAGS" | grep "^$TAG_PREFIX"))
TAG_COUNT=${#TAGS_ARRAY[@]}

echo "Found ${TAG_COUNT} tags with prefix '${TAG_PREFIX}' in Docker Hub repository:"
for TAG in "${TAGS_ARRAY[@]}"; do
    echo "${USERNAME}/${REPOSITORY}:${TAG}"
done

echo -e "\nLocal Docker images for ${USERNAME}/${REPOSITORY}:"
docker images "${USERNAME}/${REPOSITORY}"