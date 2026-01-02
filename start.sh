#!/bin/bash
set -e

echo "Starting Olympus in Production mode..."

# Define network name
NETWORK_NAME="aether-net"

# Ensure clean state
docker stack rm olympus || true
# Wait for services to shutdown
echo "Waiting for stack to be removed..."
while docker stack ls | grep -q "olympus_"; do
    echo "Stack still active, waiting..."
    sleep 2
done
echo "Stack removed."
# Ensure network exists
docker network inspect "$NETWORK_NAME" >/dev/null 2>&1 || docker network create --driver overlay --attachable "$NETWORK_NAME"

# Start the services using base and production files
docker stack deploy --prune -c docker-compose.yml -c docker-compose.prod.yml olympus

echo "Production environment deployed successfully."