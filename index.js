import express from "express";

const app = express();
const PORT = 3000;

// default point
app.get("/", (req, res) => {
  const healthInfo = {
    status: "ok",
    pod: process.env.POD_NAME || "unKNown",
    uptime: `${process.uptime().toFixed(2)} seconds`,
    timestamp: new Date().toISOString(),
    message: "The DevOps service is running ",
  };
  res.json(healthInfo);
});

// k8s server check points
app.get("/readyz", (req, res) => res.status(200).send("ready"));
app.get("/healthz", (req, res) => res.status(200).send("ok"));

// Start server
app.listen(PORT, () => {
  console.log(`Express Server running on http://localhost:${PORT}`);
});
