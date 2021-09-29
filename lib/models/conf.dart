part of amberbrooch;

class ConfModel extends ChangeNotifier {
  Conf? _conf;
  bool _initialized = false;
  bool _error = false;
  PackageInfo? _packageInfo;
  String _version = 'unknown';
  bool _outdated = false;
  late DocumentReference<Map<String, dynamic>> _confRef;

  void listen(
    FirebaseFirestore db,
    PackageInfo packageInfo,
  ) {
    debugPrint('VersionModel: listen()');
    _confRef = db.collection('service').doc('conf');
    _packageInfo = packageInfo;
    _version = '${_packageInfo!.version}+${_packageInfo!.buildNumber}';
    _confRef.snapshots().listen(
      (doc) {
        if (doc.exists) {
          debugPrint('version: exists');
          Conf provided = Conf.fromFirestoreDoc(doc);
          if (_conf != provided) {
            _conf = provided;
            _outdated = _packageInfo!.version != _conf!.version ||
                _packageInfo!.buildNumber != _conf!.buildNumber;
            _initialized = true;
            notifyListeners();
          }
        } else {
          debugPrint('version: null');
          if (_conf != null) {
            _conf = null;
            _outdated = false;
            _error = true;
            notifyListeners();
          }
        }
      },
    );
  }

  String get version => _version;
  bool get outdated => _outdated;
  bool get initialized => _initialized;
  bool get error => _error;
  Conf? get conf => _conf;

  Future<void> setPolicy(String text) async {
    await _confRef.update({
      'policy': text,
      'updatedAt': DateTime.now(),
    });
  }
}
