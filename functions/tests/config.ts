import * as admin from "firebase-admin";

const firebaseConfig = {
  databaseURL: "http://localhost:8080",
  storageBucket: "amberbrooch.appspot.com",
  projectId: "amberbrooch",
};

export const firebase = admin.initializeApp(firebaseConfig);
export const db = admin.firestore();
export const auth = admin.auth();
