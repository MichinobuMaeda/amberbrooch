/// <reference types="@types/jest" />
import {firebase, db} from "./config";
import {
  getValidUser,
  getAdminUser,
} from "../src/guard";

beforeEach(async () => {
  const ts = new Date();
  await db.collection("users").doc("admin").set({
    name: "Admin",
    valid: true,
    admin: true,
    tester: true,
    createdAt: ts,
    updatedAt: ts,
    deletedAt: null,
  });
  await db.collection("users").doc("user01").set({
    name: "Admin",
    valid: true,
    admin: false,
    tester: false,
    createdAt: ts,
    updatedAt: ts,
    deletedAt: null,
  });
  await db.collection("users").doc("invalid").set({
    name: "Admin",
    valid: false,
    admin: true,
    tester: true,
    createdAt: ts,
    updatedAt: ts,
    deletedAt: null,
  });
  await db.collection("users").doc("deleted").set({
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
  await db.collection("users").doc("admin").delete();
  await db.collection("users").doc("user01").delete();
  await db.collection("users").doc("invalid").delete();
  await db.collection("users").doc("deleted").delete();
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
  it("rejects invalid user.", async () => {
    await expect(getValidUser(firebase, "invalid"))
        .rejects.toThrow("User: invalid is not valid.");
  });
  it("rejects deleted user.", async () => {
    await expect(getValidUser(firebase, "deleted"))
        .rejects.toThrow("User: deleted has deleted.");
  });
  it("returns valid user.", async () => {
    const user01 = await getValidUser(firebase, "user01");
    expect(user01.id).toEqual("user01");
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
  it("rejects invalid user.", async () => {
    await expect(getAdminUser(firebase, "invalid"))
        .rejects.toThrow("User: invalid is not valid.");
  });
  it("rejects deleted user.", async () => {
    await expect(getAdminUser(firebase, "deleted"))
        .rejects.toThrow("User: deleted has deleted.");
  });
  it("rejects user without admin priv.", async () => {
    await expect(getAdminUser(firebase, "user01"))
        .rejects.toThrow("User: user01 is not admin.");
  });
  it("returns valid user with admin priv.", async () => {
    const admin = await getAdminUser(firebase, "admin");
    expect(admin.id).toEqual("admin");
  });
});
