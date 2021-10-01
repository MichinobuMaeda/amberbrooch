import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as express from "express";
import * as cors from "cors";
import * as guard from "./guard";
import * as httpApi from "./api";
import * as accounts from "./accounts";

const REGION = "asia-northeast1";

const firebase = admin.initializeApp();

const httpApp = express();
httpApp.use(cors({origin: true}));
httpApp.use(express.urlencoded({extended: true}));

export const api = functions.region(REGION)
    .https.onRequest(httpApi.init(firebase, httpApp));

export const createUser = functions.region(REGION)
    .https.onCall(async (data, context) => {
      await guard.admin(firebase, context.auth?.uid);
      await accounts.createUser(
          firebase,
          data.name ?? "",
          data.admin ?? false,
          data.tester ?? false
      );
    });

export const setUserName = functions.region(REGION)
    .https.onCall(async (data, context) => {
      await guard.admin(firebase, context.auth?.uid);
      await accounts.setUserName(
          firebase,
          data.uid ?? "",
          data.name ?? "",
      );
    });

export const setUserEmail = functions.region(REGION)
    .https.onCall(async (data, context) => {
      await guard.admin(firebase, context.auth?.uid);
      await accounts.setUserName(
          firebase,
          data.uid ?? "",
          data.email ?? "",
      );
    });

export const setUserPassword = functions.region(REGION)
    .https.onCall(async (data, context) => {
      await guard.admin(firebase, context.auth?.uid);
      await accounts.setUserName(
          firebase,
          data.uid ?? "",
          data.password ?? "",
      );
    });
