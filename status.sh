#!/bin/bash

# Helm Seek - Status Script for Podman
# Check the status of Helm Seek container

# Configuration
CONTAINER_NAME="helm-seek-app"
IMAGE_NAME="helm-seek"
PORT="3003"

echo "📊 Helm Seek Status Check"
echo "========================="

# Check if container is running
if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "✅ Container Status: RUNNING"
    echo "📱 Access URL: http://localhost:${PORT}"
    echo "🕐 Started: $(podman ps --format "{{.CreatedAt}}" --filter name=${CONTAINER_NAME})"
    echo ""
    echo "📋 Recent logs:"
    podman logs --tail 5 "${CONTAINER_NAME}"
elif podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "⏹️  Container Status: STOPPED"
    echo "🚀 Start with: ./run.sh"
else
    echo "❌ Container Status: NOT FOUND"
    echo "🚀 Start with: ./run.sh"
fi

echo ""
echo "🐳 Container Management:"
echo "  Start:  ./run.sh"
echo "  Stop:   ./stop.sh"
echo "  Status: ./status.sh"