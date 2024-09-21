#!/bin/bash

# Set your Docker Hub credentials and repository info
USERNAME=""
PASSWORD=""
REPOSITORY=""
TAG_PREFIX=""  # e.g., "prod-", "v1.", etc. Use "" for all tags

# Get the authentication token
TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${USERNAME}'", "password": "'${PASSWORD}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)

# Get the list of tags, sorted by last_updated (newest first)
TAGS=$(curl -s -H "Authorization: JWT ${TOKEN}" "https://hub.docker.com/v2/repositories/${USERNAME}/${REPOSITORY}/tags/?page_size=200&ordering=-last_updated" | jq -r '.results[].name')

# Filter tags based on prefix and convert to array
TAGS_ARRAY=($(echo "$TAGS" | grep "^$TAG_PREFIX"))
TAG_COUNT=${#TAGS_ARRAY[@]}

echo "Found ${TAG_COUNT} tags with prefix '${TAG_PREFIX}'"

# Keep track of how many we've processed
PROCESSED=0

# Iterate through tags
for TAG in "${TAGS_ARRAY[@]}"; do
    PROCESSED=$((PROCESSED+1))
    
    # If we've processed more than 3, remove the image
    if [ $PROCESSED -gt 3 ]; then
        echo "Removing ${USERNAME}/${REPOSITORY}:${TAG}"
        docker rmi "${USERNAME}/${REPOSITORY}:${TAG}"
    else
        echo "Keeping ${USERNAME}/${REPOSITORY}:${TAG}"
    fi
done

echo "Cleanup complete. Kept the 3 latest images with tag prefix '${TAG_PREFIX}'."

# List remaining images
echo "Remaining images:"
docker images "${USERNAME}/${REPOSITORY}"