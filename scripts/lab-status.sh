#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."
echo "=== Containers ==="
docker compose ps
echo
echo "=== IP-adresser ==="
for c in client server1 server2 backupserver; do
  ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$c" 2>/dev/null || true)
  printf '%-12s %s\n' "$c" "${ip:-inte startad}"
done
