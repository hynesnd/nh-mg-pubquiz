const quizRouter = require("express").Router();
const { getQuestions } = require("../controllers/quiz.controller");

quizRouter.route("/").get(getQuestions);

module.exports = quizRouter;
