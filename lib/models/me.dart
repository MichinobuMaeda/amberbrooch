part of amberbrooch;

class MeModel extends ChangeNotifier {
  Account? _me;

  void reset() {
    _me = null;
  }

  set me(Account? me) {
    if (_me != me) {
      _me = me;
      debugPrint('me: ${me?.id}');
      notifyListeners();
    }
  }

  Account? get me => _me;
}
