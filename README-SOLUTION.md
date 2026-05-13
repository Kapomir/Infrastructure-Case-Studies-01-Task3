# Solution Summary - Candidate Task 03

## What I Changed

### CI Workflow (`.github/workflows/ci.yml`)
Split the workflow into 2 jobs to properly handle LocalStack and artifacts:
- **test job**: starts LocalStack, waits for it to be ready (health check loop), runs lint and integration tests
- **build job**: runs after test passes, builds apps and uploads release bundle + checksums

Added health check mechanism that retries every 2 seconds (max 80 seconds) instead of just waiting blindly.

### LocalStack Bootstrap (`localstack/init/ready.d/01-bootstrap.sh`)
Added creation of Dead Letter Queue (`deployment-events-dlq`) alongside the main SQS queue. The integration tests check for all three resources (S3 bucket, queue, DLQ).

### Artifact Packaging (`scripts/package-artifacts.sh`)
Added checksum generation - now creates `checksums.txt` with SHA256 hashes of all built files. This allows verifying bundle integrity later.

### Bundle Verification (`scripts/verify-release-bundle.sh`)
Fixed the checksum validation logic to properly normalize paths and compare them. Changed from a basic `for` loop to `while IFS= read` to handle paths correctly.

## What Works Now

```bash
npm run lint            # Linting passes
npm run ci:test        # Integration tests pass (LocalStack is ready)
npm run ci:build       # All 3 apps build, artifacts are created
npm run ci:bundle:verify  # Checksums verified
```

Local development still works fine with `bash scripts/start-dev.sh`.

## Files Changed

- `.github/workflows/ci.yml` - Rewrote the workflow
- `localstack/init/ready.d/01-bootstrap.sh` - Added DLQ
- `scripts/package-artifacts.sh` - Added checksums
- `scripts/verify-release-bundle.sh` - Fixed path handling

The workflow now properly handles artifacts between jobs so you could easily add deploy steps later.
