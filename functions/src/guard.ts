import {app} from "firebase-admin";

export const getValidUser = async (
    firebase: app.App,
    uid?: string
): Promise<FirebaseFirestore.DocumentSnapshot> => {
  if (!uid) {
    throw new Error("Param uid is missing.");
  }
  const db = firebase.firestore();
  const user = await db.collection("users").doc(uid).get();
  if (!user || !user.exists) {
    throw new Error(`User: ${uid} is not exists.`);
  }
  if (!user.get("valid")) {
    throw new Error(`User: ${uid} is not valid.`);
  }
  if (user.get("deletedAt")) {
    throw new Error(`User: ${uid} has deleted.`);
  }
  return user;
};

export const getAdminUser = async (
    firebase: app.App,
    uid?: string
): Promise<FirebaseFirestore.DocumentSnapshot> => {
  const user = await getValidUser(firebase, uid);
  if (!user.get("admin")) {
    throw new Error(`User: ${uid} is not admin.`);
  }
  return user;
};
