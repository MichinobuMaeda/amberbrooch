part of amberbrooch;

class ConfModel extends ChangeNotifier {
  Conf? _conf;

  void listen(
    FirebaseFirestore db,
  ) {
    debugPrint('conf: listen()');
    db.collection('service').doc('conf').snapshots().listen(
      (doc) {
        if (doc.exists) {
          debugPrint('conf: exists');
          Conf provided = Conf(
            id: doc.id,
            url: doc.get('url'),
            policy: doc.get('policy'),
            createdAt: doc.get('createdAt').toDate(),
            updatedAt: doc.get('updatedAt').toDate(),
          );
          if (_conf != provided) {
            _conf = provided;
            notifyListeners();
          }
        } else {
          debugPrint('conf: null');
          if (_conf != null) {
            _conf = null;
            notifyListeners();
          }
        }
      },
    );
  }

  Conf? get conf => _conf;
}
