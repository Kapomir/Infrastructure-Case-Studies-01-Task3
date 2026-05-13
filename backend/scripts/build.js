const fs = require("fs");
const path = require("path");

const sourceDir = path.join(__dirname, "..", "src");
const targetDir = path.join(__dirname, "..", "dist");

fs.rmSync(targetDir, { recursive: true, force: true });
fs.mkdirSync(targetDir, { recursive: true });

for (const file of fs.readdirSync(sourceDir)) {
  fs.copyFileSync(path.join(sourceDir, file), path.join(targetDir, file));
}

const manifest = {
  app: "backend",
  builtAt: new Date().toISOString(),
  files: fs.readdirSync(targetDir)
};

fs.writeFileSync(
  path.join(targetDir, "build-manifest.json"),
  JSON.stringify(manifest, null, 2)
);

console.log("backend build complete");
