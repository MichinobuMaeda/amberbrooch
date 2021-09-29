import {Express} from "express";
import {app} from "firebase-admin";
import {updateVersion, installer, install} from "./setup";

const init = (firebase: app.App, httpApi: Express): Express => {
  const db = firebase.firestore();

  httpApi.get("/setup", async (req, res) => {
    if (await updateVersion(firebase)) {
      return res.send("OK");
    } else {
      return res.send(installer);
    }
  });

  httpApi.post("/setup", async (req, res) => {
    const ver = await db.collection("service").doc("conf").get();
    if (ver && ver.exists) {
      return res.sendStatus(406); // Not Acceptable
    }
    const {name, email, password, url, requestUrl} = req.body;
    if (!(name && email && password && url)) {
      return res.sendStatus(400); // Bad Request
    }
    const result = await install(firebase, name, email, password, url);
    return requestUrl ?
      res.redirect(requestUrl) :
      res.send(result);
  });

  return httpApi;
};

export {
  init,
};
