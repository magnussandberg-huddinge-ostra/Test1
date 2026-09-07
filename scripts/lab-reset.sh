#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."
docker compose down -v --remove-orphans
docker compose build --no-cache
docker compose up -d
echo
echo "Labbet är återställt."
docker compose ps
