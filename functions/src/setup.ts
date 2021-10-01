import {logger} from "firebase-functions";
import {app} from "firebase-admin";
import axios from "axios";
import {createHash} from "crypto";
import {nanoid} from "nanoid";
import {createUser} from "./accounts";

const updateVersion = async (firebase: app.App): Promise<boolean> => {
  const db = firebase.firestore();

  const conf = await db.collection("service").doc("conf").get();
  if (!conf || !conf.exists) {
    return false;
  }

  const res = await axios.get(
      `${conf.get("url")}version.json?check=${new Date().getTime()}`
  );
  const version = res.data.version;
  const buildNumber = res.data.build_number;

  if (
    (version !== conf.get("version")) ||
    (buildNumber !== conf.get("buildNumber"))
  ) {
    logger.info(`${version}+${buildNumber}`);

    await db.collection("service").doc("conf").update({
      version,
      buildNumber,
      updatedAt: new Date(),
    });
  }

  return true;
};

const updateData = async (firebase: app.App): Promise<boolean> => {
  const db = firebase.firestore();

  const conf = await db.collection("service").doc("conf").get();
  if (!conf || !conf.exists) {
    return false;
  }

  const dataVersion = conf.get("dataVersion") || 0;

  if (dataVersion < 1) {
    const accounts = await db.collection("accounts").get();
    await Promise.all(accounts.docs.map(async (doc) => {
      await doc.ref.update({
        themeMode: doc.get("themeMode") || null,
      });
    }));
  }

  await db.collection("service").doc("conf").update({
    dataVersion: 1,
    updatedAt: new Date(),
  });

  return true;
};

const installer = `<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Install - Amber Cabinet</title>
  </head>
  <body>
    <h1>Install</h1>
    <form action="" method="POST">
      <div>Url:</div>
      <p><input type="text" name="url" value="https://amber-cabinet.web.app/"
        style="width: 100%; max-width: 480px;" /></p>
      <div>Name:</div>
      <p><input type="text" name="name"
        style="width: 100%; max-width: 480px;" /></p>
      <div>E-mail:</div>
      <p><input type="text" name="email"
        style="width: 100%; max-width: 480px;" /></p>
      <div>Password:</div>
      <p><input type="password" name="password"
        style="width: 100%; max-width: 480px;" /></p>
      <p><input type="submit" value="Send" /></p>
      <input type="hidden" id="requestUrl" name="requestUrl" value="" />
    </form>
    <script>
document.getElementById('requestUrl').value = window.location.href
    </script>
  </body>
</html>
`;

const install = async (
    firebase: app.App,
    name: string,
    email: string,
    password: string,
    url: string
): Promise<string> => {
  const db = firebase.firestore();

  const ts = new Date();
  const hash = createHash("sha256");
  hash.update(nanoid());
  hash.update(ts.toISOString());
  hash.update(name);
  hash.update(email);
  hash.update(password);
  hash.update(url);
  const seed = hash.digest("hex");

  await db.collection("service").doc("conf").set({
    version: "1.0.0",
    buildNumber: "1",
    url,
    seed,
    invitationExpirationTime: 3 * 24 * 3600 * 1000,
    policy: `## Heading 2

### Heading 3

The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.

<https://flutter.dev/>

[Flutter](https://flutter.dev/)

- List item 1
- List item 2
- List item 3
    1. List item 3.1
    2. List item 3.2
    3. List item 3.3
- List item 4

The quick brown fox jumps over the lazy dog.

The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.

The quick brown fox jumps over the lazy dog. The quick brown fox  \
jumps over the lazy dog. The quick brown fox jumps over the lazy dog.

The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
The quick brown fox jumps over the lazy dog.
`,
    createdAt: ts,
    updatedAt: ts,
  });

  const testers = "testers";
  const uid = await createUser(
      firebase,
      name,
      true,
      true,
      testers,
      email,
      password,
  );

  await db.collection("groups").doc(testers).set({
    name: "テスト",
    desc: "テスト用のグループ",
    accounts: [uid],
    createdAt: ts,
    updatedAt: ts,
    deletedAt: null,
  });

  return "OK";
};

export {
  updateVersion,
  updateData,
  installer,
  install,
};
