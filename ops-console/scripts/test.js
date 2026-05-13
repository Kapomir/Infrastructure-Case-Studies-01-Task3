const fs = require("fs");
const path = require("path");

const html = fs.readFileSync(path.join(__dirname, "..", "src", "index.html"), "utf8");

if (!html.includes("Boss Zone")) {
  console.error("ops-console title missing");
  process.exit(1);
}

console.log("ops-console tests passed");
