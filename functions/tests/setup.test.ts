/// <reference types="@types/jest" />
import axios from "axios";
import {firebase, db, auth} from "./config";
import {
  updateVersion,
  updateData,
  install,
} from "../src/setup";

jest.mock("axios");
const mockedAxios = axios as jest.Mocked<typeof axios>;

const confRef = db.collection("service").doc("conf");
const ts = new Date("2020-01-01T00:00:00.000Z");

beforeEach(async () => {
  await confRef.set({
    version: "1.0.0",
    buildNumber: "1",
    url: "http://example.com/version.json",
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
  it("returns false if version is not exists.", async () => {
    mockedAxios.get.mockResolvedValue({
      data: {
        version: "1.0.0",
        buildNumber: "1",
      },
    });
    await confRef.delete();
    const ret = await updateVersion(firebase);
    expect(ret).toBeFalsy();
  });
  it("returns true and not modifies conf" +
      " has same version and buildNumber.", async () => {
    mockedAxios.get.mockResolvedValue({
      data: {
        version: "1.0.0",
        buildNumber: "1",
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
        buildNumber: "1",
      },
    });
    const ret = await updateVersion(firebase);
    expect(ret).toBeTruthy();
    const conf = await confRef.get();
    expect(conf.get("updatedAt").toDate()).not.toEqual(ts);
    expect(conf.get("version")).toEqual("1.0.1");
    expect(conf.get("buildNumber")).toEqual("1");
  });
  it("returns true and update conf has old buildNumber.", async () => {
    mockedAxios.get.mockResolvedValue({
      data: {
        version: "1.0.0",
        buildNumber: "2",
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

describe("updateData()", () => {
  it("return false for uninitialized database.", async () => {
    await confRef.delete();
    const ret = await updateData(firebase);
    expect(ret).toBeFalsy();
  });
  const latestDataVersion = 1;
  it("set dataVsersion.", async () => {
    const ret = await updateData(firebase);
    expect(ret).toBeTruthy();
    const conf = await confRef.get();
    expect(conf.get("dataVersion")).toEqual(latestDataVersion);
  });
  it("do nothing for latest dataVersion.", async () => {
    await updateData(firebase);
    const ret0 = await updateData(firebase);
    expect(ret0).toBeTruthy();
    const conf0 = await confRef.get();
    expect(conf0.get("dataVersion")).toEqual(latestDataVersion);
  });
  // for dataVersion: latest - 1
  // for dataVersion: latest - 2
  // ...
  // for dataVersion: 2
  // for dataVersion: 1
  it("add accounts 'themeMode' for dataVersion: 0.", async () => {
    await confRef.update({
      dataVersion: 0,
    });
    const account01Ref = db.collection("accounts").doc("account01");
    const account02Ref = db.collection("accounts").doc("account02");
    await account01Ref.set({
      valid: true,
      name: "Account 1",
      admin: true,
      tester: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    });
    await account02Ref.set({
      valid: true,
      name: "Account 2",
      admin: true,
      tester: true,
      themeMode: "dark",
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    const ret = await updateData(firebase);

    expect(ret).toBeTruthy();
    const conf = await confRef.get();
    expect(conf.get("dataVersion")).toEqual(1);
    const account01 = await account01Ref.get();
    const account02 = await account02Ref.get();
    expect(account01.get("themeMode")).toBeNull();
    expect(account02.get("themeMode")).toEqual("dark");

    await account01Ref.delete();
    await account02Ref.delete();
  });
});

describe("install()", () => {
  it("create conf, primary account in testers group," +
      " and testers group with primary account," +
      " and returns 'OK'.", async () => {
    const name = "Primary account";
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
    expect(testers.get("accounts")).toHaveLength(1);
    const uid = testers.get("accounts")[0];
    const primary = await db.collection("accounts").doc(uid).get();
    expect(primary.get("name")).toEqual(name);
    expect(primary.get("admin")).toBeTruthy();
    expect(primary.get("tester")).toBeTruthy();
    expect(primary.get("valid")).toBeTruthy();
    const account = await auth.getUser(uid);
    expect(account.displayName).toEqual(name);
    expect(account.email).toEqual(email);
    expect(account.passwordHash).toBeDefined();
    await db.collection("accounts").doc(uid).delete();
    await auth.deleteUser(uid);
  });
});
