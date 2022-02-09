const quizRouter = require("express").Router();
const { getQuestions, getScore } = require("../controllers/quiz.controller");

quizRouter.route("/").get(getQuestions);
quizRouter.route("/score").get(getScore);

module.exports = quizRouter;
