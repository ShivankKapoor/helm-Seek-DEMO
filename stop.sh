#!/bin/bash

# Helm Seek - Stop Script for Podman
# This script safely stops and cleans up only Helm Seek containers/images

set -e  # Exit on any error

# Configuration
CONTAINER_NAME="helm-seek-app"
IMAGE_NAME="helm-seek"

echo "🛑 Stopping Helm Seek..."

# Function to safely stop and remove container
stop_container() {
    if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        echo "⏹️  Stopping running container..."
        podman stop "${CONTAINER_NAME}"
    fi
    
    if podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        echo "🗑️  Removing container..."
        podman rm "${CONTAINER_NAME}"
    fi
}

# Function to safely remove image
remove_image() {
    if podman images --format "{{.Repository}}" | grep -q "^${IMAGE_NAME}$"; then
        echo "🗑️  Removing image '${IMAGE_NAME}'..."
        podman rmi "${IMAGE_NAME}"
    else
        echo "ℹ️  Image '${IMAGE_NAME}' not found"
    fi
}

# Stop and remove container
stop_container

# Ask user if they want to remove the image
read -p "🤔 Do you want to remove the Docker image '${IMAGE_NAME}' as well? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    remove_image
    echo "🧹 Complete cleanup finished!"
else
    echo "📦 Image '${IMAGE_NAME}' kept for faster future starts"
fi

# Clean up any dangling images (only if they're related to our build)
DANGLING_IMAGES=$(podman images -f "dangling=true" -q)
if [ ! -z "$DANGLING_IMAGES" ]; then
    read -p "🧹 Found dangling images. Remove them? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Removing dangling images..."
        podman rmi $DANGLING_IMAGES
    fi
fi

echo "✅ Helm Seek stopped successfully!"
echo "🚀 Start again with: ./run.sh"