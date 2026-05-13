const test = require("node:test");
const assert = require("node:assert/strict");
const { inspectResources } = require("../src/aws");

test("LocalStack-backed resources are reachable", async () => {
  process.env.AWS_ENDPOINT_URL = process.env.AWS_ENDPOINT_URL || "http://localhost:4566";
  process.env.AWS_S3_BUCKET = process.env.AWS_S3_BUCKET || "developer-snapshots";
  process.env.AWS_SQS_QUEUE_NAME = process.env.AWS_SQS_QUEUE_NAME || "deployment-events";
  process.env.AWS_SQS_DLQ_NAME = process.env.AWS_SQS_DLQ_NAME || "deployment-events-dlq";

  const result = await inspectResources();

  assert.equal(result.bucketExists, true);
  assert.equal(result.queueExists, true);
  assert.equal(result.deadLetterQueueExists, true);
  assert.equal(result.healthy, true);
});
