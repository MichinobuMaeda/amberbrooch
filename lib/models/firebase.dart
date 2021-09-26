part of amberbrooch;

const bool useEmulator = String.fromEnvironment('EMULATOR') == 'Y';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFunctions functions =
    FirebaseFunctions.instanceFor(region: functionsRegion);

class FirebaseModel extends ChangeNotifier {
  bool _initialized = false;
  bool _error = false;

  void init({
    required String deepLink,
    required AuthModel authModel,
  }) async {
    debugPrint('firebase: init()');
    try {
      if (useEmulator) {
        await auth.useAuthEmulator('localhost', emulatorPortAuth);
        db.useFirestoreEmulator('localhost', emulatorPortFirestore);
        await storage.useStorageEmulator('localhost', emulatorPortStorage);
        functions.useFunctionsEmulator('localhost', emulatorPortFunctions);
      }
      await Firebase.initializeApp();
      auth.setLanguageCode('ja');
      _initialized = true;
      debugPrint('firebase: initialized');

      String email = LocalStorage().email;
      LocalStorage().email = '';

      debugPrint(deepLink);
      debugPrint(email);
      if (auth.isSignInWithEmailLink(deepLink)) {
        await authModel.signInWithEmailLink(
          email: email,
          deepLink: deepLink,
        );
      }

      notifyListeners();
    } catch (e, s) {
      if (e.toString().contains('code=failed-precondition')) {
        _initialized = true;
        debugPrint('firebase: already initialized');
      } else {
        _error = true;
        debugPrint('firebase: error');
        debugPrint('Exception: $e');
        debugPrint('StackTrace: $s');
      }
      notifyListeners();
    }
  }

  bool get initialized => _initialized;
  bool get error => _error;
}
