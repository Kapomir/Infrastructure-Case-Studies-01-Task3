#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "[ERROR] missing required command: $1"
    exit 1
  fi
}

require_cmd npm
require_cmd docker
require_cmd curl

if [[ ! -f ".github/workflows/ci.yml" ]]; then
  echo "[ERROR] missing workflow file"
  exit 1
fi

if ! grep -Eiq 'localstack|docker compose' .github/workflows/ci.yml; then
  echo "[ERROR] workflow does not appear to provision LocalStack or docker compose"
  exit 1
fi

if ! grep -q 'ci:test' .github/workflows/ci.yml; then
  echo "[ERROR] workflow does not call ci:test"
  exit 1
fi

if ! grep -q 'ci:build' .github/workflows/ci.yml; then
  echo "[ERROR] workflow does not call ci:build"
  exit 1
fi

if ! grep -Eq 'upload-artifact|download-artifact' .github/workflows/ci.yml; then
  echo "[ERROR] workflow does not appear to handle build artifacts between jobs"
  exit 1
fi

npm install
docker compose up -d localstack

echo "[INFO] waiting for LocalStack"
for _ in $(seq 1 40); do
  if curl -fsS http://localhost:4566/_localstack/health >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

npm run lint
npm run ci:test
npm run ci:build
npm run ci:bundle:verify

if [[ ! -f artifacts/release-bundle.tgz ]]; then
  echo "[ERROR] missing artifacts/release-bundle.tgz"
  exit 1
fi

docker compose up -d --build backend frontend ops-console

echo "[INFO] waiting for backend"
for _ in $(seq 1 40); do
  if curl -fsS http://localhost:3000/health >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

curl -fsS http://localhost:3000/health | grep -q '"status":"ok"'
curl -fsS http://localhost:3000/api/status | grep -q '"bucketExists":true'
curl -fsS http://localhost:3000/api/status | grep -q '"queueExists":true'
curl -fsS http://localhost:3000/api/status | grep -q '"deadLetterQueueExists":true'
curl -fsS http://localhost:4173 | grep -q 'Launchpad Developer Portal'
curl -fsS http://localhost:4174 | grep -q 'Boss Zone'

echo "[OK] validation succeeded"
