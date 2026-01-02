#!/bin/bash
set -e

echo "Starting Olympus in Development mode..."
NETWORK_NAME="aether-net"

# Ensure clean state
echo "Waiting for stack to be removed..."
docker stack rm olympus || true
while docker stack ls | grep -q "olympus"; do
    echo "Stack still active, waiting..."
    sleep 2
done
echo "Stack removed."

# Ensure network exists (Must be overlay for Swarm)
docker network inspect "$NETWORK_NAME" >/dev/null 2>&1 || docker network create --driver overlay --attachable "$NETWORK_NAME"

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found. Please create it by copying .env.example:"
    echo "  cp .env.example .env"
    echo "Then update it with your configuration and secrets."
    exit 1
fi

# Deploy the stack using dev configuration
# Note: --prune removes services not in the new files
docker stack deploy --prune -c docker-compose.yml -c docker-compose.dev.yml olympus

echo "Development environment deployed."