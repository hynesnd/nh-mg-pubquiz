const app = require("../app");
const request = require("supertest");

describe("/api path: ", () => {
  it("Status 200: responds with Hello World", () => {
    return request(app)
      .get("/api")
      .expect(200)
      .then(({ body }) => {
        expect(body.msg).toBe("Hello World");
      });
  });
});

describe("/api/quiz path:", () => {
  describe("GET method: ", () => {
    it("Status 200: returns .json containing quiz questions", () => {
      return request(app)
        .get("/api/quiz")
        .expect(200)
        .then(({ body }) => {
          expect(Array.isArray(body.quiz)).toBe(true);
          expect(body.quiz).toHaveLength(3);
          body.quiz.forEach((qObj) => {
            expect.objectContaining({
              question: expect.any(String),
              options: expect.any(Array),
            });
          });
        });
    });
  });
});

describe("/api/quiz/score path:", () => {
  describe("GET method:", () => {
    it("Status 200: returns number of correct answers based on answers in query", () => {
      return request(app)
        .get("/api/quiz/score?q1=c&q2=a&q3=b")
        .expect(200)
        .then(({ body }) => {
          expect(body.score).toBe(3);
        });
    });

    it("Status 200: returns number of correct answers if not all are correct", () => {
      return request(app)
        .get("/api/quiz/score?q1=a&q2=a&q3=b")
        .expect(200)
        .then(({ body }) => {
          expect(body.score).toBe(2);
        });
    });
  });
});
