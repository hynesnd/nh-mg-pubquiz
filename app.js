const express = require("express");
const apiRouter = require("./routers/api.router");
const app = express();

app.use("/api", apiRouter);

//Respond 404: path not found to URLs not beginning with /api
app.all("/*", (req, res) => {
  res.status(404).send({ msg: "path not found" });
});

module.exports = app;
