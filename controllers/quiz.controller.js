const { fetchQuestions, calculateScore } = require("../models/quiz.model");

exports.getQuestions = (req, res) => {
  //call fetchQuestions then send response with questions array.
  return res.status(200).send({ quiz: fetchQuestions() });
};

exports.getScore = (req, res) => {
  //destructure answers from request query to variables q1, q2, q3
  const { q1, q2, q3 } = req.query;

  //call calculateScore with answers then send response with score.

  return res.status(200).send({ score: calculateScore(q1, q2, q3) });
};
