part of amberbrooch;

class MeModel extends ChangeNotifier {
  dynamic _sub;
  Account? _me;
  late ClientModel _clientModel;
  late FirebaseFirestore _db;

  void listen(
    FirebaseFirestore db,
    AuthModel authModel,
    ClientModel clientModel,
  ) {
    debugPrint('MeModel: listen()');

    _db = db;
    _clientModel = clientModel;
    _sub?.cancel();
    if (authModel.user == null) {
      me = null;
    } else {
      _sub = _db
          .collection('accounts')
          .doc(authModel.user!.id)
          .snapshots()
          .listen((doc) {
        Account? provided = (doc.exists) ? Account.fromFirestoreDoc(doc) : null;

        if (provided == null) {
          authModel.signOut();
        } else {
          if (!provided.valid ||
              provided.deletedAt != null ||
              (me != null &&
                  (me!.id != provided.id ||
                      me!.admin != provided.admin ||
                      me!.tester != provided.tester))) {
            authModel.signOut();
          } else {
            me = provided;
          }
        }
      });
    }
  }

  set me(Account? me) {
    if (_me != me) {
      _me = me;
      if (me != null) {
        _clientModel.themeMode = me.themeMode;
      }
      debugPrint('me: ${me?.id}');
      notifyListeners();
    }
  }

  Account? get me => _me;

  Future<void> setName(String text) async {
    if (_me == null) {
      return;
    }
    await _db.collection('accounts').doc(_me!.id).update({
      'name': text,
      'updatedAt': DateTime.now(),
    });
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
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
