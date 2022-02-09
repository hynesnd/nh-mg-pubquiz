const express = require("express");
const apiRouter = require("./routers/apiRouter");
const app = express();

app.use("/api", apiRouter);

module.exports = app;
