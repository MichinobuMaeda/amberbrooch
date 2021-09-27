part of amberbrooch;

class FirebaseModel extends ChangeNotifier {
  bool _initialized = false;
  bool _error = false;

  void init({
    required String deepLink,
    required AuthModel authModel,
    required Function initFirebase,
  }) async {
    debugPrint('firebase: init()');
    FirebaseAuth auth = authModel.auth;
    try {
      await initFirebase(useEmulator);
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
