#!/bin/bash
set -e
source ./scripts/load_env.sh
./scripts/deploy.sh "olympus_dev" docker-compose.yml docker-compose.dev.yml