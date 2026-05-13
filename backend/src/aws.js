const { S3Client, HeadBucketCommand } = require("@aws-sdk/client-s3");
const { SQSClient, GetQueueUrlCommand } = require("@aws-sdk/client-sqs");

function createAwsConfig() {
  const endpoint = process.env.AWS_ENDPOINT_URL || "http://localhost:4566";
  const region = process.env.AWS_REGION || "us-east-1";
  const accessKeyId = process.env.AWS_ACCESS_KEY_ID || "test";
  const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY || "test";

  return {
    endpoint,
    region,
    forcePathStyle: true,
    credentials: { accessKeyId, secretAccessKey }
  };
}

async function inspectResources() {
  const bucketName = process.env.AWS_S3_BUCKET || "developer-snapshots";
  const queueName = process.env.AWS_SQS_QUEUE_NAME || "deployment-events";
  const dlqName = process.env.AWS_SQS_DLQ_NAME || "deployment-events-dlq";
  const config = createAwsConfig();

  const s3 = new S3Client(config);
  const sqs = new SQSClient(config);

  let bucketExists = false;
  let queueExists = false;
  let deadLetterQueueExists = false;
  let queueUrl = null;
  let deadLetterQueueUrl = null;
  let issues = [];

  try {
    await s3.send(new HeadBucketCommand({ Bucket: bucketName }));
    bucketExists = true;
  } catch (error) {
    issues.push(`missing bucket: ${bucketName}`);
  }

  try {
    const response = await sqs.send(new GetQueueUrlCommand({ QueueName: queueName }));
    queueExists = true;
    queueUrl = response.QueueUrl || null;
  } catch (error) {
    issues.push(`missing queue: ${queueName}`);
  }

  try {
    const response = await sqs.send(new GetQueueUrlCommand({ QueueName: dlqName }));
    deadLetterQueueExists = true;
    deadLetterQueueUrl = response.QueueUrl || null;
  } catch (error) {
    issues.push(`missing queue: ${dlqName}`);
  }

  return {
    environment: process.env.APP_ENV || "local",
    awsEndpoint: config.endpoint,
    bucketName,
    queueName,
    dlqName,
    bucketExists,
    queueExists,
    deadLetterQueueExists,
    queueUrl,
    deadLetterQueueUrl,
    issues,
    healthy: bucketExists && queueExists && deadLetterQueueExists
  };
}

module.exports = {
  inspectResources
};
