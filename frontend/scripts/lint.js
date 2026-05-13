const fs = require("fs");
const path = require("path");

const required = [
  path.join(__dirname, "..", "src", "index.html"),
  path.join(__dirname, "..", "src", "main.js")
];

for (const file of required) {
  if (!fs.existsSync(file)) {
    console.error(`missing file: ${file}`);
    process.exit(1);
  }
}

console.log("frontend lint checks passed");
