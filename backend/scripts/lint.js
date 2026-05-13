const fs = require("fs");
const path = require("path");

const requiredFiles = [
  path.join(__dirname, "..", "src", "app.js"),
  path.join(__dirname, "..", "src", "aws.js"),
  path.join(__dirname, "..", "src", "server.js")
];

for (const file of requiredFiles) {
  if (!fs.existsSync(file)) {
    console.error(`missing required file: ${file}`);
    process.exit(1);
  }
}

console.log("backend lint checks passed");
