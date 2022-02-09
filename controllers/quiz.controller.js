const { fetchQuestions } = require("../models/quiz.model");

exports.getQuestions = (req, res) => {
  fetchQuestions().then((questions) => {
    res.status(200).send({ quiz: questions });
  });
};
