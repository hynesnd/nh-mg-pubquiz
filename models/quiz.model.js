const fsPromises = require("fs").promises;
const path = require("path");

exports.fetchQuestions = () => {
  //Read the .json containing the quiz questions and parse it.
  return fsPromises
    .readFile(path.resolve(__dirname, "../quizes/quiz.json"), "utf-8")
    .then((data) => {
      let quiz = JSON.parse(data);

      //Map removes the answer key from each quiz question before returning to controller.
      return quiz.map((qObj) => {
        delete qObj.answer;
        return qObj;
      });
    });
};

exports.calculateScore = (...answers) => {
  //Arguments from controller function call are placed in answers array.
  //Read the .json containing the quiz questions and parse it.
  return fsPromises
    .readFile(path.resolve(__dirname, "../quizes/quiz.json"), "utf-8")
    .then((data) => {
      let quiz = JSON.parse(data);
      // initialise score at 0
      let score = 0;
      /*iterate through answers and check value against answer key for each question.
        increment score for matching answer*/
      answers.forEach((answer, i) => {
        if (answer === quiz[i].answer) {
          score++;
        }
      });
      return score;
    });
};
