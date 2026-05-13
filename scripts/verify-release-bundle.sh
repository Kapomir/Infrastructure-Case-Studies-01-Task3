#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ARTIFACT_DIR="$ROOT_DIR/artifacts"
BUNDLE_DIR="$ARTIFACT_DIR/release"
UNPACK_DIR="$ARTIFACT_DIR/unpacked"

[[ -f "$ARTIFACT_DIR/release-bundle.tgz" ]]
[[ -d "$BUNDLE_DIR/frontend" ]]
[[ -d "$BUNDLE_DIR/backend" ]]
[[ -d "$BUNDLE_DIR/ops-console" ]]
[[ -f "$BUNDLE_DIR/release-manifest.json" ]]
[[ -f "$ARTIFACT_DIR/checksums.txt" ]]

grep -q 'frontend' "$BUNDLE_DIR/release-manifest.json"
grep -q 'backend' "$BUNDLE_DIR/release-manifest.json"
grep -q 'ops-console' "$BUNDLE_DIR/release-manifest.json"

# Verify checksums
echo "Verifying checksums..."

if [[ ! -d "$UNPACK_DIR" ]]; then
    mkdir -p "$UNPACK_DIR"
    echo "[OK] created unpack directory at $UNPACK_DIR"
fi

tar -xzf "$ARTIFACT_DIR/release-bundle.tgz" -C "$UNPACK_DIR"
cd "$UNPACK_DIR/release"
find . -type f -exec shasum -a 256 {} \; > $ARTIFACT_DIR/calculated.txt

while IFS= read -r line; do
    expected_checksum=$(echo "$line" | awk '{print $1}')
    file_path=$(echo "$line" | awk '{print $2}')

    # Normalize path: extract relative path from artifacts/release/
    relative_path=$(echo "$file_path" | sed 's|.*/release/||')

    # Search in calculated.txt using relative path format (./...)
    calculated_checksum=$(grep " \\./$relative_path$" $ARTIFACT_DIR/calculated.txt | awk '{print $1}')

    if [[ "$expected_checksum" != "$calculated_checksum" ]]; then
        echo "Checksum mismatch for $file_path"
        echo "Expected: $expected_checksum"
        echo "Calculated: $calculated_checksum"
        exit 1
    fi
done < "$ARTIFACT_DIR/checksums.txt"

echo "[OK] release bundle verified"
