const fs = require("fs");
const path = require("path");

const html = fs.readFileSync(path.join(__dirname, "..", "src", "index.html"), "utf8");

if (!html.includes("Launchpad Developer Portal")) {
  console.error("frontend title missing");
  process.exit(1);
}

console.log("frontend tests passed");
