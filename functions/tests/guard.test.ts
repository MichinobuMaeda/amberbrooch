/// <reference types="@types/jest" />
import {firebase, db} from "./config";
import {
  getValidUser,
  getAdminUser,
} from "../src/guard";

beforeEach(async () => {
  const ts = new Date();
  await db.collection("accounts").doc("admin").set({
    name: "Admin",
    valid: true,
    admin: true,
    tester: true,
    createdAt: ts,
    updatedAt: ts,
    deletedAt: null,
  });
  await db.collection("accounts").doc("account01").set({
    name: "Admin",
    valid: true,
    admin: false,
    tester: false,
    createdAt: ts,
    updatedAt: ts,
    deletedAt: null,
  });
  await db.collection("accounts").doc("invalid").set({
    name: "Admin",
    valid: false,
    admin: true,
    tester: true,
    createdAt: ts,
    updatedAt: ts,
    deletedAt: null,
  });
  await db.collection("accounts").doc("deleted").set({
    name: "Admin",
    valid: true,
    admin: true,
    tester: true,
    createdAt: ts,
    updatedAt: ts,
    deletedAt: ts,
  });
});

afterEach(async () => {
  await db.collection("accounts").doc("admin").delete();
  await db.collection("accounts").doc("account01").delete();
  await db.collection("accounts").doc("invalid").delete();
  await db.collection("accounts").doc("deleted").delete();
});

afterAll(async () => {
  await firebase.delete();
});

describe("getValidUser()", () => {
  it("rejects undefined uid.", async () => {
    await expect(getValidUser(firebase))
        .rejects.toThrow("Param uid is missing.");
  });
  it("rejects uid without doc.", async () => {
    await expect(getValidUser(firebase, "dummy"))
        .rejects.toThrow("User: dummy is not exists.");
  });
  it("rejects invalid account.", async () => {
    await expect(getValidUser(firebase, "invalid"))
        .rejects.toThrow("User: invalid is not valid.");
  });
  it("rejects deleted account.", async () => {
    await expect(getValidUser(firebase, "deleted"))
        .rejects.toThrow("User: deleted has deleted.");
  });
  it("returns valid account.", async () => {
    const account01 = await getValidUser(firebase, "account01");
    expect(account01.id).toEqual("account01");
    const admin = await getValidUser(firebase, "admin");
    expect(admin.id).toEqual("admin");
  });
});

describe("getAdminUser()", () => {
  it("rejects undefined uid.", async () => {
    await expect(getAdminUser(firebase))
        .rejects.toThrow("Param uid is missing.");
  });
  it("rejects uid without doc.", async () => {
    await expect(getAdminUser(firebase, "dummy"))
        .rejects.toThrow("User: dummy is not exists.");
  });
  it("rejects invalid account.", async () => {
    await expect(getAdminUser(firebase, "invalid"))
        .rejects.toThrow("User: invalid is not valid.");
  });
  it("rejects deleted account.", async () => {
    await expect(getAdminUser(firebase, "deleted"))
        .rejects.toThrow("User: deleted has deleted.");
  });
  it("rejects account without admin priv.", async () => {
    await expect(getAdminUser(firebase, "account01"))
        .rejects.toThrow("User: account01 is not admin.");
  });
  it("returns valid account with admin priv.", async () => {
    const admin = await getAdminUser(firebase, "admin");
    expect(admin.id).toEqual("admin");
  });
});
