#!/bin/bash
set -e
# Usage: ./scripts/deploy.sh <STACK_NAME> [COMPOSE_FILES...]
./scripts/deploy.sh "olympus" docker-compose.yml docker-compose.prod.yml