const fsPromises = require("fs").promises;
const path = require("path");

exports.fetchQuestions = () => {
  return fsPromises
    .readFile(path.resolve(__dirname, "../quizes/quiz.json"), "utf-8")
    .then((data) => {
      let quiz = JSON.parse(data);
      return quiz.map((qObj) => {
        delete qObj.answer;
        return qObj;
      });
    });
};
