part of amberbrooch;

class AuthModel extends ChangeNotifier {
  final String deepLink;
  AuthUser? _user;
  UserCredential? _userCredential;
  DateTime? _authenticatedAt;
  late FirebaseAuth _auth;
  late ClientModel _clientModel;

  AuthModel(this.deepLink);

  void listen(
    FirebaseAuth auth,
    FirebaseFirestore db,
    MeModel meModel,
    ClientModel clientModel,
  ) {
    debugPrint('AuthModel: listen()');

    _auth = auth;
    _clientModel = clientModel;
    String email = LocalStorage().email;
    LocalStorage().email = '';

    debugPrint(deepLink);
    debugPrint(email);
    if (auth.isSignInWithEmailLink(deepLink)) {
      signInWithEmailLink(
        email: email,
        deepLink: deepLink,
      );
    }

    auth.authStateChanges().listen(
      (User? user) {
        setUser(user, db, meModel);
      },
    );

    if (auth.currentUser != null) {
      setUser(auth.currentUser, db, meModel);
    }
  }

  void setUser(
    User? user,
    FirebaseFirestore db,
    MeModel meModel,
  ) async {
    if (user == null) {
      if (_user != null) {
        _user = null;
        debugPrint('AuthModel: null');
        meModel.listen(db, this, _clientModel);
      }
    } else {
      AuthUser provided = AuthUser(
        id: user.uid,
        email: user.email,
        emailVerified: user.emailVerified,
      );
      if (_user != provided) {
        if (_user?.emailVerified != true && provided.emailVerified) {
          notifyListeners();
        }
        _user = provided;
        debugPrint('AuthModel: ' + _user!.id);
        if (meModel.me?.id != _user!.id) {
          meModel.listen(db, this, _clientModel);
        }
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
    await _auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: url,
        handleCodeInApp: true,
      ),
    );
    LocalStorage().email = email;
  }

  Future<void> sendEmailVerification() async {
    await _auth.currentUser!.sendEmailVerification();
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool resetRecord = false,
  }) async {
    _userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _authenticatedAt = DateTime.now();
    if (resetRecord) {
      _userCredential = null;
      _authenticatedAt = null;
    }
  }

  Future<void> signInWithEmailLink({
    required String email,
    required String deepLink,
  }) async {
    _userCredential = await _auth.signInWithEmailLink(
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
    await _auth.sendSignInLinkToEmail(
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
      email: _auth.currentUser!.email ?? '',
      password: password,
    );
    _userCredential =
        await _auth.currentUser!.reauthenticateWithCredential(credential);
    _authenticatedAt = DateTime.now();
    notifyListeners();
  }

  Future<void> setMyEmail(String email) async {
    await _auth.currentUser!.updateEmail(email);
    await _auth.currentUser!.reload();
  }

  Future<void> setMyPassword(String password) async {
    await _auth.currentUser!.updatePassword(password);
    await _auth.currentUser!.reload();
  }

  Future<void> reload() async {
    await _auth.currentUser?.reload();
    if (_auth.currentUser == null) {
      return;
    }
    AuthUser provided = AuthUser(
      id: _auth.currentUser!.uid,
      email: _auth.currentUser!.email,
      emailVerified: _auth.currentUser!.emailVerified,
    );
    if (_user != provided) {
      if (_user?.emailVerified != true && provided.emailVerified) {
        notifyListeners();
      }
      _user = provided;
    }
  }

  Future<void> signOut() async {
    _userCredential = null;
    _authenticatedAt = null;
    await _auth.signOut();
  }
}
