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

  void init({required String deepLink}) async {
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

      String? email = html.window.localStorage['amberbrooch_email'];
      html.window.localStorage['amberbrooch_email'] = '';

      debugPrint(deepLink);
      debugPrint(email);
      if (auth.isSignInWithEmailLink(deepLink)) {
        if (RegExp(r'reauthenticate=yes').hasMatch(deepLink)) {
          // AuthCredential credential = EmailAuthProvider.credentialWithLink(
          //     email: email ?? '', emailLink: deepLink);
          // _tempCredential = await auth.currentUser
          //     ?.reauthenticateWithCredential(credential);
          // appContents = AppContents.me;
        } else {
          await auth.signInWithEmailLink(
            email: email ?? '',
            emailLink: deepLink,
          );
        }
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
