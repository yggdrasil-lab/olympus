#!/bin/bash
set -e
source ./scripts/load_env.sh
./scripts/deploy.sh --skip-build "olympus_dev" docker-compose.yml docker-compose.dev.yml