part of amberbrooch;

class VersionModel extends ChangeNotifier {
  Version? _ver;
  bool _initialized = false;

  void listen() {
    debugPrint('version: listen()');
    db.collection('service').doc('version').snapshots().listen(
      (doc) {
        if (doc.exists) {
          debugPrint('version: exists');
          Version provided = Version(
            id: doc.id,
            version: doc.get('version'),
            buildNumber: doc.get('buildNumber'),
            createdAt: doc.get('createdAt').toDate(),
            updatedAt: doc.get('updatedAt').toDate(),
          );
          if (_ver != provided) {
            _ver = provided;
            notifyListeners();
          }
        } else {
          debugPrint('version: null');
          if (!_initialized || _ver != null) {
            _ver = null;
            notifyListeners();
          }
        }
        _initialized = true;
      },
    );
  }

  Version? get version => _ver;
  bool get initialized => _initialized;
}
