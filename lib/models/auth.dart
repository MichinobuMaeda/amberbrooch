part of amberbrooch;

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth;
  AuthUser? _user;

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
}
