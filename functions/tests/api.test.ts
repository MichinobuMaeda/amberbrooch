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

const verRef = db.collection("service").doc("version");
const ts = new Date("2020-01-01T00:00:00.000Z");

afterAll(async () => {
  await firebase.delete();
});

describe("get: /setup", () => {
  it("send the installer if document 'ver' is not exists.", async () => {
    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.get("/setup");

    expect(response.status).toBe(200);
    expect(response.text).toMatch("<h1>Install</h1>");
  });
  it("send text 'OK' if document 'ver' is exists.", async () => {
    await verRef.set({
      version: "1.0.0",
      buildNumber: "1",
      createdAt: ts,
      updatedAt: ts,
    });

    mockedAxios.get.mockResolvedValue({
      data: {
        version: "1.0.0",
        build_number: "1",
      },
    });

    const app = express();
    app.use(express.urlencoded({extended: true}));
    const request = supertest(init(firebase, app));
    const response = await request.get("/setup");

    expect(response.status).toBe(200);
    expect(response.text).toEqual("OK");

    await verRef.delete();
  });
});

describe("post: /setup", () => {
  it("send text 'OK' if document 'version' is not exists " +
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

    await verRef.delete();
  });
  it("send status 302 if document 'version' is not exists " +
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

    await verRef.delete();
  });
  it("send status 400 if document 'version' is not exists " +
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

    await verRef.delete();
  });
  it("send status 400 if document 'version' is not exists " +
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

    await verRef.delete();
  });
  it("send status 400 if document 'version' is not exists " +
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

    await verRef.delete();
  });
  it("send status 400 if document 'version' is not exists " +
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

    await verRef.delete();
  });
  it("send status 406 if document 'version' is exists.", async () => {
    await verRef.set({
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

    await verRef.delete();
  });
});
