#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ARTIFACT_DIR="$ROOT_DIR/artifacts"
BUNDLE_DIR="$ARTIFACT_DIR/release"

rm -rf "$ARTIFACT_DIR"
mkdir -p "$BUNDLE_DIR"

cp -R "$ROOT_DIR/frontend/dist" "$BUNDLE_DIR/frontend"
cp -R "$ROOT_DIR/backend/dist" "$BUNDLE_DIR/backend"
cp -R "$ROOT_DIR/ops-console/dist" "$BUNDLE_DIR/ops-console"

cat > "$BUNDLE_DIR/release-manifest.json" <<'JSON'
{
  "bundle": "launchpad-release",
  "includes": ["frontend", "backend", "ops-console"],
  "createdBy": "scripts/package-artifacts.sh",
  "notes": [
    "Checksums should be generated for shipped artifacts",
    "Artifact verification is expected in CI"
  ]
}
JSON

# Generate checksums for all files in the bundle
echo "Generating checksums..."
find "$BUNDLE_DIR" -type f -exec shasum -a 256 {} \; >> "$ARTIFACT_DIR/checksums.txt"
echo "[OK] checksums generated at $ARTIFACT_DIR/checksums.txt"

tar -C "$ARTIFACT_DIR" -czf "$ARTIFACT_DIR/release-bundle.tgz" release
echo "[OK] created $ARTIFACT_DIR/release-bundle.tgz"
