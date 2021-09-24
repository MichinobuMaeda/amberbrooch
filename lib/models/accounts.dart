part of amberbrooch;

class AccountsModel extends ChangeNotifier {
  final List<Account> list = [];
  dynamic _sub;

  Future<void> listen(
    String? uid,
    Function realoadApp,
    Function signOut,
    MeModel meModel,
    GroupsModel groupsModel,
    GroupModel groupModel,
  ) async {
    if (meModel.me?.id == uid) {
      return;
    }

    debugPrint('accounts: listen($uid)');

    if (uid == null) {
      cancel();
      groupsModel.cancel();
      meModel.reset();
      groupModel.reset();
      return;
    }

    Account? me = _castDoc(await db.collection('accounts').doc(uid).get());

    if (!me.valid || me.deletedAt != null) {
      debugPrint('accounts: valid=${me.valid}, deletedAt=${me.deletedAt}');
      signOut();
      return;
    }

    if (meModel.me != null && meModel.me!.admin != me.admin) {
      debugPrint('accounts: admin=${me.admin}');
      signOut();
      return;
    }

    _sub?.cancel();
    _sub = null;
    meModel.me = me;

    if (meModel.me!.admin) {
      _sub = db.collection('accounts').snapshots().listen((snapshot) {
        for (var change in snapshot.docChanges) {
          void notify() => groupsModel.listen(meModel, groupModel);
          switch (change.type) {
            case DocumentChangeType.added:
              Account account = _castDoc(change.doc);
              list.add(account);
              if (change.doc.id == uid) {
                _setMe(meModel, account, notify);
              }

              break;
            case DocumentChangeType.modified:
              list.removeWhere((doc) => doc.id == change.doc.id);
              Account account = _castDoc(change.doc);
              list.add(account);
              if (change.doc.id == uid) {
                _setMe(meModel, account, notify);
              }
              break;
            case DocumentChangeType.removed:
              list.removeWhere((doc) => doc.id == change.doc.id);
              if (change.doc.id == uid) {
                _setMe(meModel, null, notify);
              }
              break;
          }
        }
        debugPrint('Accounts updated (admin)');
        notifyListeners();
      });
    } else {
      _sub = db.collection('accounts').doc(uid).snapshots().listen((doc) {
        void notify() => groupsModel.listen(meModel, groupModel);
        if (doc.exists) {
          Account account = _castDoc(doc);
          list.replaceRange(0, list.length, [account]);
          _setMe(meModel, account, notify);
        } else {
          list.clear();
          _setMe(meModel, null, notify);
        }
        debugPrint('Accounts updated (not admin)');
        notifyListeners();
      });
    }
  }

  void _setMe(MeModel meModel, Account? me, Function notify) {
    if (meModel.me != me) {
      if (me == null) {
        debugPrint('accounts: me is null');
        signOut();
        return;
      } else if (!me.valid || me.deletedAt != null) {
        debugPrint('accounts: valid=${me.valid}, deletedAt=${me.deletedAt}');
        if (meModel.me != null) {
          signOut();
        }
        return;
      } else {
        meModel.me = me;
        notify();
      }
    }
  }

  void cancel() {
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
