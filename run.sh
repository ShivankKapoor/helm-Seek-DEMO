#!/bin/bash

# Helm Seek - Run Script for Podman
# This script safely runs the Helm Seek container without affecting other containers

set -e  # Exit on any error

# Configuration
CONTAINER_NAME="helm-seek-app"
IMAGE_NAME="helm-seek"
PORT="3003"
HOST_PORT="3003"

echo "🚀 Starting Helm Seek with Podman..."

# Check if container is already running
if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "⚠️  Container '${CONTAINER_NAME}' is already running!"
    echo "📱 Access it at: http://localhost:${HOST_PORT}"
    exit 0
fi

# Check if stopped container exists
if podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "🔄 Removing existing stopped container..."
    podman rm "${CONTAINER_NAME}"
fi

# Check if image exists, build if not
if ! podman images --format "{{.Repository}}" | grep -q "^${IMAGE_NAME}$"; then
    echo "🔨 Building Helm Seek image..."
    podman build -t "${IMAGE_NAME}" .
else
    echo "✅ Image '${IMAGE_NAME}' already exists"
fi

# Run the container
echo "🐳 Starting container..."
podman run -d \
    --name "${CONTAINER_NAME}" \
    -p "${HOST_PORT}:${PORT}" \
    --restart unless-stopped \
    "${IMAGE_NAME}"

# Verify container is running
sleep 2
if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "✅ Container started successfully!"
    echo "📱 Access Helm Seek at: http://localhost:${HOST_PORT}"
    echo "🔍 Container logs: podman logs ${CONTAINER_NAME}"
    echo "🛑 Stop with: ./stop.sh"
else
    echo "❌ Failed to start container"
    echo "📋 Check logs: podman logs ${CONTAINER_NAME}"
    exit 1
fi