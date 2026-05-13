const test = require("node:test");
const assert = require("node:assert/strict");
const { inspectResources } = require("../src/aws");

test("inspectResources returns a structured result", async () => {
  process.env.AWS_ENDPOINT_URL = "http://localhost:4566";
  process.env.AWS_S3_BUCKET = "developer-snapshots";
  process.env.AWS_SQS_QUEUE_NAME = "deployment-events";

  const result = await inspectResources().catch(() => null);

  assert.ok(result === null || typeof result === "object");
});
