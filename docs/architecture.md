# Architecture overview

## Services
- frontend: simple developer portal
- backend: express API exposing health and local AWS status
- ops-console: lightweight operations page for "boss mode"
- localstack: local AWS emulator for S3 and SQS

## Simulated AWS resources
- S3 bucket: `developer-snapshots`
- SQS queue: `deployment-events`

## Backend responsibilities
The backend checks whether required AWS resources exist and exposes that through `/api/status`.
It uses the AWS SDK with an endpoint pointed to LocalStack.

## Why this task exists
Developers need a repeatable environment that behaves like "cloud enough" for local work.
The platform team also wants CI to validate that the simulated environment actually works.
