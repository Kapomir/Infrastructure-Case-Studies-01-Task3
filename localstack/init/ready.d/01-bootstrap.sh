#!/usr/bin/env sh
set -eu

awslocal s3 mb s3://developer-snapshots || true
awslocal sqs create-queue --queue-name deployment-events >/dev/null 2>&1 || true

# TODO: platform team recently added a DLQ for deployment workflows.
# Keep LocalStack bootstrap aligned with backend expectations.

echo "LocalStack bootstrap complete"
