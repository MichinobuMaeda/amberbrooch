import {logger} from "firebase-functions";
import {app} from "firebase-admin";
import {createHash} from "crypto";
import {nanoid} from "nanoid";

const createAccount = async (
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

  const account = await db.collection("accounts").add({
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

  const uid = account.id;
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
  await db.collection("accounts").doc(uid).update({
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
  await db.collection("accounts").doc(uid).update({
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
  const accounts = await db.collection("accounts")
      .where("invitation", "==", invitation).get();
  if (accounts.docs.length !== 1) {
    throw new Error("No record");
  }
  const account = accounts.docs[0];
  if (!account.get("invitedAt") || !account.get("invitedBy")) {
    await account.ref.update({
      invitation: null,
      invitedBy: null,
      invitedAt: null,
    });
    throw new Error(
        `Invitation for account: ${account.id} has invalid status.`
    );
  }
  const expired = new Date().getTime() - conf.get("invitationExpirationTime");
  if (account.get("invitedAt").toDate().getTime() < expired) {
    await account.ref.update({
      invitation: null,
      invitedBy: null,
      invitedAt: null,
    });
    throw new Error(`Invitation for account: ${account.id} is expired.`);
  }
  const token = await auth.createCustomToken(account.id);
  logger.info(`Invited account: ${account.id} get token: ${token}`);
  return token;
};

export {
  createAccount as createUser,
  setUserName,
  setUserEmail,
  setUserPassword,
  invite,
  getToken,
};
