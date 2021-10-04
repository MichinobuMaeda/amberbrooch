part of amberbrooch;

class ServiceModel extends ChangeNotifier {
  final bool useEmulator;
  final String deepLink;
  bool _initialized = false;
  bool _error = false;
  Conf? _conf;
  AuthUser? _user;
  DateTime? _authenticatedAt;
  Account? _me;
  dynamic _subMe;

  late FirebaseAuth _auth;
  late FirebaseFirestore _db;
  late FirebaseStorage _storage;
  late FirebaseFunctions _functions;
  late ClientModel _clientModel;

  ServiceModel({
    required this.useEmulator,
    required this.deepLink,
  });

  bool get initialized => _initialized;
  bool get error => _error;
  Conf? get conf => _conf;
  AuthUser? get user => _user;
  bool get reAuthed =>
      _authenticatedAt != null &&
      _authenticatedAt!.millisecondsSinceEpoch >=
          DateTime.now().millisecondsSinceEpoch - reAuthExpriedMilliSec;
  Account? get me => _me;

  Future<void> listen({
    required FirebaseAuth auth,
    required FirebaseFirestore db,
    required FirebaseStorage storage,
    required FirebaseFunctions functions,
    required ClientModel clientModel,
  }) async {
    _auth = auth;
    _db = db;
    _storage = storage;
    _functions = functions;
    _clientModel = clientModel;

    debugPrint('Service: (useEmulator: $useEmulator, deepLink: $deepLink)');

    try {
      if (useEmulator) {
        await _auth.useAuthEmulator('localhost', emulatorPortAuth);
        _db.useFirestoreEmulator('localhost', emulatorPortFirestore);
        await _storage.useStorageEmulator('localhost', emulatorPortStorage);
        _functions.useFunctionsEmulator('localhost', emulatorPortFunctions);
      }
      await Firebase.initializeApp();
      _initialized = true;
    } catch (e) {
      if (e.toString().contains('code=failed-precondition')) {
        _initialized = true;
        debugPrint('firebase: already initialized');
      } else {
        _error = true;
      }
    }

    debugPrint('Firebase: initialized');
    notifyListeners();

    if (!_initialized) {
      return;
    }

    debugPrint('serice.conf: listen');
    _db.collection('service').doc('conf').snapshots().listen(
      (doc) {
        if (doc.exists) {
          debugPrint('serice.conf: exists');
          Conf provided = Conf.fromFirestoreDoc(doc);
          if (_conf != provided) {
            _conf = provided;
            notifyListeners();
          }
        } else {
          debugPrint('serice.conf: null');
          if (_conf != null) {
            _conf = null;
            _error = true;
            notifyListeners();
          }
        }
      },
    );

    String email = _clientModel.email;
    _clientModel.email = '';
    debugPrint(email);

    _auth.setLanguageCode('ja');

    debugPrint('auth: evaluate deepLink');
    if (auth.isSignInWithEmailLink(deepLink)) {
      signInWithEmailLink(
        email: email,
        deepLink: deepLink,
      );
    }

    debugPrint('auth: listen');
    auth.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          if (_user != null) {
            _user = null;
            debugPrint('AuthModel: null');
            _subMe?.cancel();
            _setMe(null);
          }
        } else {
          AuthUser provided = AuthUser(
            id: user.uid,
            email: user.email,
            emailVerified: user.emailVerified,
          );

          if (_user != provided) {
            final bool emailVerified =
                _user?.emailVerified != true && provided.emailVerified;
            _user = provided;
            debugPrint('AuthModel: ' + _user!.id);

            if (me?.id != _user!.id) {
              debugPrint('accounts.me: listen');
              _subMe = _db
                  .collection('accounts')
                  .doc(_user?.id)
                  .snapshots()
                  .listen((doc) {
                Account? provided =
                    (doc.exists) ? Account.fromFirestoreDoc(doc) : null;

                if (provided == null) {
                  signOut();
                } else {
                  if (!provided.valid ||
                      provided.deletedAt != null ||
                      (me != null &&
                          (me!.id != provided.id ||
                              me!.admin != provided.admin ||
                              me!.tester != provided.tester))) {
                    signOut();
                  } else {
                    _setMe(provided);
                  }
                }
              });
            }

            if (emailVerified) {
              notifyListeners();
            }
          }
        }
      },
    );
  }

  void _setMe(Account? me) {
    if (_me != me) {
      _me = me;
      if (me != null) {
        _clientModel.themeMode = me.themeMode;
      }
      debugPrint('me: ${me?.id}');
      notifyListeners();
    }
  }

  Future<void> setPolicy(String text) async {
    await _db.collection('service').doc('conf').update({
      'policy': text,
      'updatedAt': DateTime.now(),
    });
  }

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
    _clientModel.email = email;
  }

  Future<void> sendEmailVerification() async {
    await _auth.currentUser!.sendEmailVerification();
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool resetRecord = false,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _authenticatedAt = DateTime.now();
    if (resetRecord) {
      _authenticatedAt = null;
    }
  }

  Future<void> signInWithEmailLink({
    required String email,
    required String deepLink,
  }) async {
    await _auth.signInWithEmailLink(
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
    _clientModel.email = email;
  }

  Future<void> reauthenticateWithPassword(String password) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: _auth.currentUser!.email ?? '',
      password: password,
    );
    await _auth.currentUser!.reauthenticateWithCredential(credential);
    _authenticatedAt = DateTime.now();
    notifyListeners();
  }

  Future<void> reloadAuthUser() async {
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

  Future<void> signOut({BuildContext? context}) async {
    if (context != null) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    _authenticatedAt = null;
    await _auth.signOut();
  }

  Future<void> setMyEmail(String email) async {
    await _auth.currentUser!.updateEmail(email);
    await _auth.currentUser!.reload();
  }

  Future<void> setMyPassword(String password) async {
    await _auth.currentUser!.updatePassword(password);
    await _auth.currentUser!.reload();
  }

  Future<void> setMyName(String text) async {
    if (_me == null) {
      return;
    }
    await _db.collection('accounts').doc(_me!.id).update({
      'name': text,
      'updatedAt': DateTime.now(),
    });
  }

  Future<void> setMyThemeMode(ThemeMode themeMode) async {
    if (_me == null) {
      return;
    }
    await _db.collection('accounts').doc(_me!.id).update({
      'themeMode': themeMode == ThemeMode.system
          ? 'system'
          : themeMode == ThemeMode.dark
              ? 'dark'
              : 'light',
      'updatedAt': DateTime.now(),
    });
  }
}
