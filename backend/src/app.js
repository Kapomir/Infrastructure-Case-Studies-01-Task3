const express = require("express");
const { inspectResources } = require("./aws");

function createApp() {
  const app = express();

  app.get("/health", (req, res) => {
    res.status(200).json({ status: "ok", service: "backend" });
  });

  app.get("/api/status", async (req, res) => {
    try {
      const details = await inspectResources();
      res.status(details.healthy ? 200 : 503).json({
        service: "backend",
        ...details
      });
    } catch (error) {
      res.status(500).json({
        service: "backend",
        error: error.message
      });
    }
  });

  app.get("/api/admin/report", async (req, res) => {
    const expectedToken = process.env.OPS_TOKEN || "boss-mode";
    const incoming = req.header("x-ops-token");
    if (incoming !== expectedToken) {
      return res.status(403).json({ error: "forbidden" });
    }

    const details = await inspectResources();
    res.json({
      title: "Boss Zone operational report",
      generatedAt: new Date().toISOString(),
      apps: ["frontend", "backend", "ops-console"],
      aws: details
    });
  });

  return app;
}

module.exports = {
  createApp
};
