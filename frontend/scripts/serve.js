const http = require("http");
const fs = require("fs");
const path = require("path");

const port = Number(process.env.PORT || 4173);
const dist = path.join(__dirname, "..", "dist");

const mime = {
  ".html": "text/html; charset=utf-8",
  ".js": "application/javascript; charset=utf-8"
};

const server = http.createServer((req, res) => {
  const urlPath = req.url === "/" ? "/index.html" : req.url;
  const file = path.join(dist, urlPath);

  if (!fs.existsSync(file)) {
    res.writeHead(404);
    res.end("not found");
    return;
  }

  const ext = path.extname(file);
  res.writeHead(200, { "Content-Type": mime[ext] || "text/plain; charset=utf-8" });
  res.end(fs.readFileSync(file));
});

server.listen(port, () => {
  console.log(`frontend listening on port ${port}`);
});
