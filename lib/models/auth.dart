part of amberbrooch;

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth;
  AuthUser? _user;
  UserCredential? _userCredential;
  DateTime? _authenticatedAt;

  AuthModel(this._auth);

  void listen() {
    debugPrint('auth: listen()');
    _auth.authStateChanges().listen((User? user) {
      _updateUser(user);
    });
  }

  Future<void> reload() async {
    if (auth.currentUser != null) {
      await auth.currentUser!.reload();
      _updateUser(auth.currentUser);
    }
  }

  void _updateUser(User? user) {
    if (user == null) {
      if (_user != null) {
        _user = null;
        debugPrint('auth: null');
        notifyListeners();
      }
    } else {
      AuthUser provided = AuthUser(
        id: user.uid,
        email: user.email,
        emailVerified: user.emailVerified,
      );
      if (_user != provided) {
        _user = provided;
        debugPrint('auth: ' + _user!.id);
        notifyListeners();
      }
    }
  }

  AuthUser? get user => _user;

  bool get reAuthed =>
      _userCredential != null &&
      _authenticatedAt != null &&
      _authenticatedAt!.millisecondsSinceEpoch >=
          DateTime.now().millisecondsSinceEpoch - reAuthExpriedMilliSec;

  Future<void> sendSignInLinkToEmail({
    required String email,
    required String url,
  }) async {
    await auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: url,
        handleCodeInApp: true,
      ),
    );
    LocalStorage().email = email;
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _authenticatedAt = DateTime.now();
  }

  Future<void> signInWithEmailLink({
    required String email,
    required String deepLink,
  }) async {
    _userCredential = await auth.signInWithEmailLink(
      email: email,
      emailLink: deepLink,
    );
    _authenticatedAt = DateTime.now();
  }

  Future<void> reauthenticateWithEmailLink({
    required String url,
  }) async {
    final String email = _user?.email ?? '';
    final String emailLink = url;
    await auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: emailLink,
        handleCodeInApp: true,
      ),
    );
    LocalStorage().email = email;
  }

  Future<void> reauthenticateWithPassword(String password) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: auth.currentUser?.email ?? '',
      password: password,
    );
    _userCredential =
        await auth.currentUser!.reauthenticateWithCredential(credential);
    _authenticatedAt = DateTime.now();
    notifyListeners();
  }

  Future<void> setMyEmail(String email) async {
    await auth.currentUser!.updateEmail(email);
    await auth.currentUser!.reload();
  }

  Future<void> setMyPassword(String password) async {
    await auth.currentUser!.updatePassword(password);
    await auth.currentUser!.reload();
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
