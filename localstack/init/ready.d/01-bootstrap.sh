#!/usr/bin/env sh
set -eu

awslocal s3 mb s3://developer-snapshots || true
awslocal sqs create-queue --queue-name deployment-events >/dev/null 2>&1 || true
awslocal sqs create-queue --queue-name deployment-events-dlq >/dev/null 2>&1 || true

echo "LocalStack bootstrap complete"
