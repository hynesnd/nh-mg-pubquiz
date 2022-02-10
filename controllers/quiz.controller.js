const { fetchQuestions, calculateScore } = require("../models/quiz.model");

exports.getQuestions = (req, res) => {
  //call fetchQuestions then send response with questions array.
  fetchQuestions().then((questions) => {
    res.status(200).send({ quiz: questions });
  });
};

exports.getScore = (req, res) => {
  //destructure answers from request query to variables q1, q2, q3
  const { q1, q2, q3 } = req.query;

  //call calculateScore with answers then send response with score.
  calculateScore(q1, q2, q3).then((score) => {
    res.status(200).send({ score });
  });
};
