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
