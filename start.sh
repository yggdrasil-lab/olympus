#!/bin/bash

# Check if the aether-net network exists
if ! docker network ls | grep -q "aether-net"; then
  echo "Creating aether-net network..."
  docker network create aether-net
else
  echo "aether-net network already exists."
fi

# Start the services
docker compose up -d --remove-orphans
