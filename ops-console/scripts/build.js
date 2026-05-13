const fs = require("fs");
const path = require("path");

const sourceDir = path.join(__dirname, "..", "src");
const distDir = path.join(__dirname, "..", "dist");

fs.rmSync(distDir, { recursive: true, force: true });
fs.mkdirSync(distDir, { recursive: true });

for (const file of fs.readdirSync(sourceDir)) {
  fs.copyFileSync(path.join(sourceDir, file), path.join(distDir, file));
}

console.log("ops-console build complete");
