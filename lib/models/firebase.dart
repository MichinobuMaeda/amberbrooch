part of amberbrooch;

class FirebaseModel extends ChangeNotifier {
  final bool useEmulator;
  bool initialized = false;
  bool error = false;

  FirebaseModel(this.useEmulator);

  Future<void> listen({
    required FirebaseAuth auth,
    required FirebaseFirestore db,
    required FirebaseStorage storage,
    required FirebaseFunctions functions,
    required AuthModel authModel,
    required ConfModel confModel,
    required MeModel meModel,
    required ClientModel clientModel,
  }) async {
    debugPrint('FirebaseModel: listen()');
    try {
      if (useEmulator) {
        await auth.useAuthEmulator('localhost', emulatorPortAuth);
        db.useFirestoreEmulator('localhost', emulatorPortFirestore);
        await storage.useStorageEmulator('localhost', emulatorPortStorage);
        functions.useFunctionsEmulator('localhost', emulatorPortFunctions);
      }
      await Firebase.initializeApp();
      initialized = true;
    } catch (e) {
      if (e.toString().contains('code=failed-precondition')) {
        initialized = true;
        debugPrint('firebase: already initialized');
      } else {
        error = true;
      }
    }

    notifyListeners();

    if (initialized) {
      auth.setLanguageCode('ja');
      authModel.listen(auth, db, meModel, clientModel);
      confModel.listen(db, await PackageInfo.fromPlatform());
    }
  }
}
