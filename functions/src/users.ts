import {logger} from "firebase-functions";
import {app} from "firebase-admin";
import {createHash} from "crypto";
import {nanoid} from "nanoid";

const createUser = async (
    firebase: app.App,
    name: string,
    admin: boolean,
    tester: boolean,
    group?: string,
    email?: string,
    password?: string,
): Promise<string> => {
  logger.info({name, admin, tester, group, email, password: !!password});
  const db = firebase.firestore();
  const auth = firebase.auth();

  if (name.length == 0) {
    throw new Error("Param name is missing.");
  }

  if (email?.length == 0) {
    throw new Error("Param email is empty.");
  }

  if (password?.length == 0) {
    throw new Error("Param password is empty.");
  }

  const ts = new Date();

  const user = await db.collection("users").add({
    name,
    admin,
    tester,
    valid: true,
    group: group || null,
    invitation: null,
    invitedBy: null,
    invitedAt: null,
    createdAt: ts,
    updatedAt: ts,
    deletedAt: null,
  });

  const uid = user.id;
  const displayName = name;

  const profile = email ?
  password ?
      {uid, displayName, email: email, password: password} :
      {uid, displayName, email: email} :
    {uid, displayName};
  await auth.createUser(profile);

  await db.collection("people").doc(uid).set({
    groups: group ? [group] : [],
    createdAt: ts,
    updatedAt: ts,
    deletedAt: null,
  });

  return uid;
};

const setUserName = async (
    firebase: app.App,
    uid: string,
    name: string
): Promise<void> => {
  const db = firebase.firestore();
  const auth = firebase.auth();

  if (name.length == 0) {
    throw new Error("Param name is missing.");
  }

  await auth.updateUser(uid, {displayName: name});
  await db.collection("users").doc(uid).update({
    name,
    updatedAt: new Date(),
  });
};

const setUserEmail = async (
    firebase: app.App,
    uid: string,
    email: string
): Promise<void> => {
  const auth = firebase.auth();

  if (email.length == 0) {
    throw new Error("Param email is empty.");
  }

  logger.info(`setUserEmail: ${uid}, ${email}`);
  await auth.updateUser(uid, {email});
};

const setUserPassword = async (
    firebase: app.App,
    uid: string,
    password: string
): Promise<void> => {
  const auth = firebase.auth();

  if (password.length == 0) {
    throw new Error("Param password is empty.");
  }

  logger.info(`setUserPassword: ${uid}`);
  await auth.updateUser(uid, {password});
};

const calcInvitation = (
    code: string,
    seed: string
): string => {
  const hash = createHash("sha256");
  hash.update(code);
  hash.update(seed);
  return hash.digest("hex");
};

const invite = async (
    firebase: app.App,
    caller: FirebaseFirestore.DocumentSnapshot,
    uid: string
): Promise<string> => {
  const db = firebase.firestore();
  const invitedBy = caller.id;

  logger.info(`setUserEmail ${JSON.stringify({invitedBy, uid})}`);
  const conf = await db.collection("service").doc("conf").get();
  const code = nanoid();
  const ts = new Date();
  const invitation = calcInvitation(code, conf.get("seed"));
  await db.collection("users").doc(uid).update({
    invitation,
    invitedBy,
    invitedAt: ts,
    updatedAt: ts,
  });
  return code;
};

const getToken = async (
    firebase: app.App,
    code: string
): Promise<string> => {
  const db = firebase.firestore();
  const auth = firebase.auth();

  logger.info(`getToken: ${code}`);
  const conf = await db.collection("service").doc("conf").get();
  const invitation = calcInvitation(code, conf.get("seed"));
  const users = await db.collection("users")
      .where("invitation", "==", invitation).get();
  if (users.docs.length !== 1) {
    throw new Error("No record");
  }
  const user = users.docs[0];
  if (!user.get("invitedAt") || !user.get("invitedBy")) {
    await user.ref.update({
      invitation: null,
      invitedBy: null,
      invitedAt: null,
    });
    throw new Error(`Invitation for user: ${user.id} has invalid status.`);
  }
  const expired = new Date().getTime() - conf.get("invitationExpirationTime");
  if (user.get("invitedAt").toDate().getTime() < expired) {
    await user.ref.update({
      invitation: null,
      invitedBy: null,
      invitedAt: null,
    });
    throw new Error(`Invitation for user: ${user.id} is expired.`);
  }
  const token = await auth.createCustomToken(user.id);
  logger.info(`Invited user: ${user.id} get token: ${token}`);
  return token;
};

export {
  createUser,
  setUserName,
  setUserEmail,
  setUserPassword,
  invite,
  getToken,
};
