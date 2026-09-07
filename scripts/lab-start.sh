#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."
docker compose up -d --build
echo
echo "Labbet är startat."
docker compose ps
