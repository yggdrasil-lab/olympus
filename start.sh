#!/bin/bash
set -e

echo "Starting Olympus in Production mode..."

# Define network name
NETWORK_NAME="aether-net"

# Ensure clean state
docker compose -f docker-compose.yml -f docker-compose.prod.yml down --remove-orphans

# Ensure network exists
docker network inspect "$NETWORK_NAME" >/dev/null 2>&1 || docker network create --driver overlay --attachable "$NETWORK_NAME"

# Start the services using docker stack deploy (Swarm Mode)
docker compose -f docker-compose.yml -f docker-compose.prod.yml config | docker stack deploy -c - olympus

echo "Production environment deployed successfully."