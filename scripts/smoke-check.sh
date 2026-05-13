#!/usr/bin/env bash
set -euo pipefail

curl -fsS http://localhost:3000/health >/dev/null
curl -fsS http://localhost:3000/api/status | grep -q '"bucketExists":true'
curl -fsS http://localhost:3000/api/status | grep -q '"queueExists":true'
curl -fsS http://localhost:4173 | grep -q 'Launchpad Developer Portal'
curl -fsS http://localhost:4174 | grep -q 'Boss Zone'

echo "[OK] smoke checks passed"
