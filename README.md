# Candidate Task 03 - CI/CD pipeline with LocalStack-powered AWS simulation

## Scenario
You are joining a platform team that maintains a small internal product called **Launchpad**.

The repository contains:
- `frontend/` - developer-facing web UI,
- `backend/` - API used by the frontend and by operational tooling,
- `ops-console/` - "boss zone" for DevOps / platform visibility,
- `localstack/` - AWS simulation for local development.

The team wants one repository that developers can run locally **without touching a real AWS account**.
To support that, the project uses **LocalStack** to simulate:
- an S3 bucket: `developer-snapshots`
- an SQS queue: `deployment-events`
- a dead-letter queue: `deployment-events-dlq`

The local environment mostly works, but the CI/CD pipeline is incomplete and does not properly validate the AWS-dependent parts of the system.

## What is intentionally wrong or incomplete
The current pipeline in `.github/workflows/ci.yml`:
- installs dependencies,
- runs only part of the checks,
- does not fully provision LocalStack-backed dependencies,
- does not run the LocalStack-backed integration tests in a robust way,
- does not build every app correctly,
- does not create a proper release bundle for deployment,
- does not verify artifact integrity or move artifacts cleanly between jobs.

This is intentional.

## Your task
Update the repository so that:
1. CI validates all parts of the monorepo.
2. LocalStack is started and ready before integration tests run.
3. Integration tests for the backend pass against the simulated AWS resources.
4. All three applications are built:
   - `frontend`
   - `backend`
   - `ops-console`
5. A release bundle is created from built artifacts.
6. The release bundle contains a manifest **and checksums for shipped artifacts**.
7. The workflow handles artifacts in a way another engineer could extend to later stages (for example deploy/promote jobs).
8. The repository remains usable for local developer onboarding.

You may modify:
- `.github/workflows/ci.yml`
- scripts in `scripts/`
- package scripts
- docker / compose files
- build configuration
- other files if needed

## Expected local commands
Your final solution should support:

```bash
npm install
npm run lint
npm run ci:test
npm run ci:build
npm run ci:bundle:verify
bash scripts/start-dev.sh
bash scripts/validate-solution.sh
```

## Validation rules
The validation script checks at minimum:
- the workflow file contains CI logic for LocalStack-backed testing,
- the workflow references artifact handoff between jobs,
- `npm run ci:test` succeeds,
- `npm run ci:build` succeeds,
- the release bundle is created,
- the release bundle includes checksums,
- backend `/health` returns 200,
- backend `/api/status` confirms LocalStack resources exist,
- `frontend` is reachable,
- `ops-console` is reachable.

## Notes
- This is a CI/CD task, not a frontend styling exercise.
- Keep changes pragmatic.
- You do not need to connect to real AWS.
- Prefer a solution that another engineer could understand and maintain.
- The repository is intentionally close to working, but there are a few cross-cutting gaps between pipeline, LocalStack bootstrap, Docker/dev scripts and release packaging.

## Helpful starting points
- `localstack/init/ready.d/01-bootstrap.sh`
- `scripts/package-artifacts.sh`
- `scripts/verify-release-bundle.sh`
- `backend/tests/status.integration.test.js`
- `.github/workflows/ci.yml`

## Deliverables
- working repository
- fixed CI/CD workflow
- updated scripts / configs if needed
- optional `README-SOLUTION.md` with your assumptions
