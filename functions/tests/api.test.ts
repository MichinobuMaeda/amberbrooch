/// <reference types="@types/jest" />
import * as supertest from "supertest";
import * as express from "express";
import axios from "axios";
import {firebase, db} from "./config";
import {
  init,
} from "../src/api";

jest.mock("axios");
const mockedAxios = axios as jest.Mocked<typeof axios>;

const confRef = db.collection("service").doc("conf");
const ts = new Date("2020-01-01T00:00:00.000Z");

afterAll(async () => {
  await firebase.delete();
});

describe("get: /setup", () => {
  it("send the installer if document 'conf' is not exists.", async () => {
    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.get("/setup");

    expect(response.status).toBe(200);
    expect(response.text).toMatch("<h1>Install</h1>");
  });
  it("send text 'OK' if document 'conf' is exists.", async () => {
    await confRef.set({
      version: "1.0.0",
      buildNumber: "1",
      createdAt: ts,
      updatedAt: ts,
    });

    mockedAxios.get.mockResolvedValue({
      data: {
        version: "1.0.0",
        buildNumber: "1",
      },
    });

    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.get("/setup");

    expect(response.status).toBe(200);
    expect(response.text).toEqual("OK");

    await confRef.delete();
  });
});

describe("post: /setup", () => {
  it("send text 'OK' if document 'conf' is not exists " +
      "for request without requestUrl.", async () => {
    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.post("/setup").send(
        "name=Test%201" +
        "&email=test1@example.com" +
        "&password=password" +
        "&url=http%3A%2F%2Flocalhost%3A5000%2F"
    );

    expect(response.status).toBe(200);
    expect(response.text).toEqual("OK");

    await confRef.delete();
  });
  it("send status 302 if document 'conf' is not exists " +
      "for request with requestUrl.", async () => {
    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.post("/setup").send(
        "name=Test%2012" +
        "&email=test2@example.com" +
        "&password=password" +
        "&url=http%3A%2F%2Flocalhost%3A5000%2F" +
        "&requestUrl=http%3A%2F%2Flocalhost%3A5000%2F"
    );

    expect(response.status).toBe(302);

    await confRef.delete();
  });
  it("send status 400 if document 'conf' is not exists " +
      "for request without name.", async () => {
    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.post("/setup").send(
        // "name=Test%2013" +
        "&email=test3@example.com" +
        "&password=password" +
        "&url=http%3A%2F%2Flocalhost%3A5000%2F" +
        "&requestUrl=http%3A%2F%2Flocalhost%3A5000%2F"
    );

    expect(response.status).toBe(400);

    await confRef.delete();
  });
  it("send status 400 if document 'conf' is not exists " +
      "for request without email.", async () => {
    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.post("/setup").send(
        "name=Test%2013" +
        // "&email=test3@example.com" +
        "&password=password" +
        "&url=http%3A%2F%2Flocalhost%3A5000%2F" +
        "&requestUrl=http%3A%2F%2Flocalhost%3A5000%2F"
    );

    expect(response.status).toBe(400);

    await confRef.delete();
  });
  it("send status 400 if document 'conf' is not exists " +
      "for request without password.", async () => {
    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.post("/setup").send(
        "name=Test%2013" +
        "&email=test3@example.com" +
        // "&password=password" +
        "&url=http%3A%2F%2Flocalhost%3A5000%2F" +
        "&requestUrl=http%3A%2F%2Flocalhost%3A5000%2F"
    );

    expect(response.status).toBe(400);

    await confRef.delete();
  });
  it("send status 400 if document 'conf' is not exists " +
      "for request without url.", async () => {
    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.post("/setup").send(
        "name=Test%2013" +
        "&email=test3@example.com" +
        "&password=password" +
        // "&url=http%3A%2F%2Flocalhost%3A5000%2F" +
        "&requestUrl=http%3A%2F%2Flocalhost%3A5000%2F"
    );

    expect(response.status).toBe(400);

    await confRef.delete();
  });
  it("send status 406 if document 'conf' is exists.", async () => {
    await confRef.set({
      version: "1.0.0",
      buildNumber: "1",
      createdAt: ts,
      updatedAt: ts,
    });

    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.post("/setup");

    expect(response.status).toBe(406);

    await confRef.delete();
  });
});
