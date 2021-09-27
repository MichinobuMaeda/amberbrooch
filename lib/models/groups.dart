part of amberbrooch;

class GroupsModel extends ChangeNotifier {
  final List<Group> list = [];
  dynamic _sub;

  Future<void> listen(
    FirebaseFirestore db,
    MeModel meModel,
    GroupModel groupModel,
  ) async {
    _sub?.cancel();
    _sub = null;
    list.clear();

    if (meModel.me == null) {
      return;
    }

    debugPrint('groups: listen(${meModel.me?.id})');

    _sub = (meModel.me!.admin
            ? db.collection('groups')
            : db.collection('groups').where(
                  'accounts',
                  arrayContains: meModel.me!.id,
                ))
        .orderBy('name')
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            Group group = _castDoc(change.doc);
            list.add(group);
            debugPrint('Groups added: ${change.doc.id}');
            if (change.doc.id == meModel.me!.group) {
              groupModel.group = group;
              notifyListeners();
            }
            break;
          case DocumentChangeType.modified:
            list.removeWhere((doc) => doc.id == change.doc.id);
            Group group = _castDoc(change.doc);
            list.add(group);
            debugPrint('Groups modified: ${change.doc.id}');
            if (change.doc.id == meModel.me!.group) {
              groupModel.group = group;
              notifyListeners();
            }
            break;
          case DocumentChangeType.removed:
            list.removeWhere((doc) => doc.id == change.doc.id);
            debugPrint('Groups removed: ${change.doc.id}');
            if (change.doc.id == meModel.me!.group) {
              groupModel.group = null;
              notifyListeners();
            }
            break;
        }
      }
      debugPrint('Groups updated');
      notifyListeners();
    });
  }

  void reset() {
    debugPrint('groups: cancel');
    _sub?.cancel();
    list.clear();
  }

  Group _castDoc(dynamic doc) => Group(
        id: doc.id,
        name: doc.get('name'),
        desc: doc.get('desc'),
        accounts: doc
            .get('accounts')
            .map<String>(
              (val) => val.toString(),
            )
            .toList(),
        createdAt: doc.get('createdAt').toDate(),
        updatedAt: doc.get('updatedAt').toDate(),
        deletedAt: doc.get('deletedAt')?.toDate(),
      );
}
