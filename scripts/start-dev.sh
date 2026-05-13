#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

docker compose up -d --build localstack backend frontend ops-console

echo "[OK] services started"
echo "backend: http://localhost:3000/health"
echo "frontend: http://localhost:4173"
echo "ops-console: http://localhost:4174"
