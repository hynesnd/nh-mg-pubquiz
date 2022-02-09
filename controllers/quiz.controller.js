const { fetchQuestions, calculateScore } = require("../models/quiz.model");

exports.getQuestions = (req, res) => {
  fetchQuestions().then((questions) => {
    res.status(200).send({ quiz: questions });
  });
};

exports.getScore = (req, res) => {
  const { q1, q2, q3 } = req.query;

  calculateScore(q1, q2, q3).then((score) => {
    res.status(200).send({ score });
  });
};
