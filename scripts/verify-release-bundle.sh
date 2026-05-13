#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ARTIFACT_DIR="$ROOT_DIR/artifacts"
BUNDLE_DIR="$ARTIFACT_DIR/release"

[[ -f "$ARTIFACT_DIR/release-bundle.tgz" ]]
[[ -d "$BUNDLE_DIR/frontend" ]]
[[ -d "$BUNDLE_DIR/backend" ]]
[[ -d "$BUNDLE_DIR/ops-console" ]]
[[ -f "$BUNDLE_DIR/release-manifest.json" ]]
[[ -f "$BUNDLE_DIR/checksums.txt" ]]

grep -q 'frontend' "$BUNDLE_DIR/release-manifest.json"
grep -q 'backend' "$BUNDLE_DIR/release-manifest.json"
grep -q 'ops-console' "$BUNDLE_DIR/release-manifest.json"
grep -q 'sha256' "$BUNDLE_DIR/checksums.txt"

echo "[OK] release bundle verified"
