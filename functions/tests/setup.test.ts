/// <reference types="@types/jest" />
import axios from "axios";
import {firebase, db, auth} from "./config";
import {
  updateVersion,
  install,
} from "../src/setup";

jest.mock("axios");
const mockedAxios = axios as jest.Mocked<typeof axios>;

const confRef = db.collection("service").doc("conf");
const ts = new Date("2020-01-01T00:00:00.000Z");

beforeEach(async () => {
  await confRef.set({
    url: "http://example.com/version.json",
    version: "1.0.0",
    buildNumber: "1",
    createdAt: ts,
    updatedAt: ts,
  });
});

afterEach(async () => {
  await confRef.delete();
});

afterAll(async () => {
  await firebase.delete();
});

describe("updateVersion()", () => {
  it("returns false if conf is not exists.", async () => {
    mockedAxios.get.mockResolvedValue({
      data: {
        version: "1.0.0",
        build_number: "1",
      },
    });
    await confRef.delete();
    const ret = await updateVersion(firebase);
    expect(ret).toBeFalsy();
  });
  it("returns true and not modifies conf" +
      " has same version and build_number.", async () => {
    mockedAxios.get.mockResolvedValue({
      data: {
        version: "1.0.0",
        build_number: "1",
      },
    });
    const ret = await updateVersion(firebase);
    expect(ret).toBeTruthy();
    const conf = await confRef.get();
    expect(conf.get("updatedAt").toDate()).toEqual(ts);
  });
  it("returns true and update conf has old version.", async () => {
    mockedAxios.get.mockResolvedValue({
      data: {
        version: "1.0.1",
        build_number: "1",
      },
    });
    const ret = await updateVersion(firebase);
    expect(ret).toBeTruthy();
    const conf = await confRef.get();
    expect(conf.get("updatedAt").toDate()).not.toEqual(ts);
    expect(conf.get("version")).toEqual("1.0.1");
    expect(conf.get("buildNumber")).toEqual("1");
  });
  it("returns true and update conf has old build_number.", async () => {
    mockedAxios.get.mockResolvedValue({
      data: {
        version: "1.0.0",
        build_number: "2",
      },
    });
    const ret = await updateVersion(firebase);
    expect(ret).toBeTruthy();
    const conf = await confRef.get();
    expect(conf.get("updatedAt").toDate()).not.toEqual(ts);
    expect(conf.get("version")).toEqual("1.0.0");
    expect(conf.get("buildNumber")).toEqual("2");
  });
});

describe("install()", () => {
  it("create conf, primary user in testers group," +
      " and testers group with primary user," +
      " and returns 'OK'.", async () => {
    const name = "Primary user";
    const email = "primary@example.com";
    const password = "primary's password";
    const url = "https://example.com";
    await confRef.delete();
    const ret = await install(firebase, name, email, password, url);
    expect(ret).toEqual("OK");
    const conf = await confRef.get();
    expect(conf.get("url")).toEqual(url);
    expect(conf.get("seed")).toBeDefined();
    const testers = await db.collection("groups").doc("testers").get();
    expect(testers.get("users")).toHaveLength(1);
    const uid = testers.get("users")[0];
    const primary = await db.collection("users").doc(uid).get();
    expect(primary.get("name")).toEqual(name);
    expect(primary.get("admin")).toBeTruthy();
    expect(primary.get("tester")).toBeTruthy();
    expect(primary.get("valid")).toBeTruthy();
    expect(primary.get("group")).toEqual("testers");
    const user = await auth.getUser(uid);
    expect(user.displayName).toEqual(name);
    expect(user.email).toEqual(email);
    expect(user.passwordHash).toBeDefined();
    await db.collection("users").doc(uid).delete();
    await auth.deleteUser(uid);
  });
});