const apiRouter = require("express").Router();

apiRouter.get("/", (req, res) => {
  res.status(200).send({ msg: "Hello World" });
});

module.exports = apiRouter;
