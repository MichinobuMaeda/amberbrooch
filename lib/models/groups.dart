part of amberbrooch;

class GroupsModel extends ChangeNotifier {
  Account? _me;
  final List<Group> list = [];
  dynamic _sub;

  Future<void> listen(MeModel meModel, GroupModel groupModel) async {
    if (_me == meModel.me) {
      return;
    }

    _me = meModel.me;
    _sub?.cancel();
    _sub = null;
    debugPrint('groups: listen(${_me?.id})');

    if (_me != null && _me!.valid && _me!.deletedAt == null) {
      _sub = (_me!.admin
              ? db.collection('groups')
              : db.collection('groups').where(
                    'accounts',
                    arrayContains: _me!.id,
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
              if (change.doc.id == _me!.group) {
                groupModel.group = group;
                notifyListeners();
              }
              break;
            case DocumentChangeType.modified:
              list.removeWhere((doc) => doc.id == change.doc.id);
              Group group = _castDoc(change.doc);
              list.add(group);
              debugPrint('Groups modified: ${change.doc.id}');
              if (change.doc.id == _me!.group) {
                groupModel.group = group;
                notifyListeners();
              }
              break;
            case DocumentChangeType.removed:
              list.removeWhere((doc) => doc.id == change.doc.id);
              debugPrint('Groups removed: ${change.doc.id}');
              if (change.doc.id == _me!.group) {
                groupModel.group = null;
                notifyListeners();
              }
              break;
          }
        }
        debugPrint('Groups updated');
        notifyListeners();
      });
    } else {
      debugPrint('Groups cleared');
      groupModel.group = null;
      list.clear();
    }
  }

  void cancel() {
    debugPrint('groups: cancel');
    _sub?.cancel();
    list.clear();
  }

  Group _castDoc(dynamic doc) => Group(
        id: doc.id,
        name: doc.get('name'),
        desc: doc.get('desc'),
        accounts:
            doc.get('accounts').map<String>((val) => val.toString()).toList(),
        createdAt: doc.get('createdAt').toDate(),
        updatedAt: doc.get('updatedAt').toDate(),
        deletedAt: doc.get('deletedAt')?.toDate(),
      );
}
