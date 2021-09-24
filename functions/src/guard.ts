import {app} from "firebase-admin";

export const getValidUser = async (
    firebase: app.App,
    uid?: string
): Promise<FirebaseFirestore.DocumentSnapshot> => {
  if (!uid) {
    throw new Error("Param uid is missing.");
  }
  const db = firebase.firestore();
  const account = await db.collection("accounts").doc(uid).get();
  if (!account || !account.exists) {
    throw new Error(`User: ${uid} is not exists.`);
  }
  if (!account.get("valid")) {
    throw new Error(`User: ${uid} is not valid.`);
  }
  if (account.get("deletedAt")) {
    throw new Error(`User: ${uid} has deleted.`);
  }
  return account;
};

export const getAdminUser = async (
    firebase: app.App,
    uid?: string
): Promise<FirebaseFirestore.DocumentSnapshot> => {
  const account = await getValidUser(firebase, uid);
  if (!account.get("admin")) {
    throw new Error(`User: ${uid} is not admin.`);
  }
  return account;
};
