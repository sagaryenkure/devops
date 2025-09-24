import express from "express";

const app = express();
const PORT = 3000;

const GOOGLE_ANALYTICS_ID = process.env.GOOGLE_ANALYTICS_ID || "null";
const USER_ID = "rtuvxy23tu3bd833dhxb98vh7";
const AUTH_TOKEN =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30";

app.get("/api", (req, res) => {
  res.json({
    message: "Hello from the devops api!",
    googleAnalyticsId: GOOGLE_ANALYTICS_ID,
    userId: USER_ID,
    authToken: AUTH_TOKEN,
  });
});

// default endpoint
app.get("/", (req, res) => {
  const healthInfo = {
    status: "ok",
    pod: process.env.POD_NAME || "unknown",
    uptime: `${process.uptime().toFixed(2)} seconds`,
    timestamp: new Date().toISOString(),
    message: "The devops api is running smoothly!",
  };
  res.json(healthInfo);
});

// k8s server check points
app.get("/readyz", (req, res) => res.status(200).send("ready"));
app.get("/healthz", (req, res) => res.status(200).send("ok"));

// catch-all for unknown routes (must be last!)
app.use((req, res) => {
  res.status(404).json({ error: `Route ${req.originalUrl} not found` });
});

// start server
app.listen(PORT, () => {
  console.log(`🚀 Express server running on http://localhost:${PORT}`);
});
