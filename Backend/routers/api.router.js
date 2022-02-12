const apiRouter = require("express").Router();
const quizRouter = require("./quiz.router");

apiRouter.get("/", (req, res) => {
  res.status(200).send({ msg: "Hello World" });
});
apiRouter.use("/quiz", quizRouter);

module.exports = apiRouter;
