const fsPromises = require("fs").promises;
const path = require("path");
const quiz = require("../../quizes/quiz.json");

exports.fetchQuestions = () => {
  const quizWithoutAnswers = quiz.map(({ answer, ...remainingValues }) => ({
    ...remainingValues,
  }));
  return quizWithoutAnswers;
};
exports.calculateScore = (...answers) => {
  let score = 0;

  answers.forEach((answer, i) => {
    if (answer === quiz[i].answer) {
      score++;
    }
  });

  return score;
};
