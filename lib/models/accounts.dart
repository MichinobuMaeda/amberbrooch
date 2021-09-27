part of amberbrooch;

class AccountsModel extends ChangeNotifier {
  final List<Account> list = [];
  dynamic _sub;

  Future<void> listen(
    FirebaseFirestore db,
    Function realoadApp,
    AuthModel authModel,
    MeModel meModel,
    GroupsModel groupsModel,
    GroupModel groupModel,
  ) async {
    AuthUser? authUser = authModel.user;
    debugPrint('accounts: listen(${authUser?.id})');

    void resetUserData() {
      reset();
      groupsModel.reset();
      meModel.reset();
      groupModel.reset();
    }

    Account? isUpdated(Account? me) {
      if (me == null ||
          !me.valid ||
          me.deletedAt != null ||
          (meModel.me != null &&
              (meModel.me!.id != me.id ||
                  meModel.me!.admin != me.admin ||
                  meModel.me!.tester != me.tester))) {
        resetUserData();
        authModel.signOut();
        return null;
      } else if (meModel.me == me) {
        return null;
      } else if (meModel.me == null) {
        return me;
      } else {
        if (meModel.me!.group != me.group) {
          groupModel.group = groupsModel.list
              .singleWhereOrNull((element) => element.id == me.group);
        }
        meModel.me = me;
        return null;
      }
    }

    if (authUser == null) {
      if (meModel.me != null) {
        resetUserData();
      }
      return;
    }

    dynamic doc = await db.collection('accounts').doc(authUser.id).get();
    Account? me = isUpdated(
      (doc == null || !doc.exists) ? null : _castDoc(doc),
    );

    if (me == null) {
      return;
    }

    meModel.me = me;
    groupsModel.listen(db, meModel, groupModel);
    notifyListeners();

    if (meModel.me!.admin) {
      _sub = db.collection('accounts').snapshots().listen((snapshot) {
        Account? me = meModel.me;

        for (var change in snapshot.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              Account account = _castDoc(change.doc);
              list.add(account);
              if (change.doc.id == meModel.me?.id) {
                me = _castDoc(change.doc);
              }
              break;
            case DocumentChangeType.modified:
              list.removeWhere((doc) => doc.id == change.doc.id);
              Account account = _castDoc(change.doc);
              list.add(account);
              if (change.doc.id == meModel.me?.id) {
                me = _castDoc(change.doc);
              }
              break;
            case DocumentChangeType.removed:
              list.removeWhere((doc) => doc.id == change.doc.id);
              if (change.doc.id == meModel.me?.id) {
                me = null;
              }
              break;
          }
        }
        me = isUpdated(me);
        if (me != null) {
          meModel.me = me;
        } else {
          notifyListeners();
        }
      });
    } else {
      _sub = db
          .collection('accounts')
          .doc(meModel.me?.id)
          .snapshots()
          .listen((doc) {
        me = isUpdated(doc.exists ? _castDoc(doc) : null);
        if (me != null) {
          list.replaceRange(0, list.length, [me!]);
          meModel.me = me;
        } else {
          notifyListeners();
        }
      });
    }
  }

  void reset() {
    debugPrint('accounts: cancel');
    _sub?.cancel();
    list.clear();
  }

  Account _castDoc(dynamic doc) => Account(
        id: doc.id,
        name: doc.get('name'),
        group: doc.get('group'),
        valid: doc.get('valid'),
        admin: doc.get('admin'),
        tester: doc.get('tester'),
        invitation: doc.get('invitation'),
        invitedBy: doc.get('invitedBy'),
        invitedAt: doc.get('invitedAt')?.toDate(),
        createdAt: doc.get('createdAt').toDate(),
        updatedAt: doc.get('updatedAt').toDate(),
        deletedAt: doc.get('deletedAt')?.toDate(),
      );
}
