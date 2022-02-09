const app = require("../app");
const request = require("supertest");

describe("/api testing: ", () => {
  it("Status 200: responds with Hello World", () => {
    return request(app)
      .get("/api")
      .expect(200)
      .then(({ body }) => {
        expect(body.msg).toBe("Hello World");
      });
  });
});
