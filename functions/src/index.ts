import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as express from "express";
import * as cors from "cors";
import {getAdminUser} from "./guard";
import {initApi} from "./api";
import * as accounts from "./accounts";

const REGION = "asia-northeast1";

const firebase = admin.initializeApp();

const httpApi = express();
httpApi.use(cors({origin: true}));
httpApi.use(express.urlencoded({extended: true}));

export const api = functions.region(REGION)
    .https.onRequest(initApi(firebase, httpApi));

export const createUser = functions.region(REGION)
    .https.onCall(async (data, context) => {
      await getAdminUser(firebase, context.auth?.uid);
      await accounts.createUser(
          firebase,
          data.name ?? "",
          data.admin ?? false,
          data.tester ?? false
      );
    });
