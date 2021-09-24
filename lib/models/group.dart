part of amberbrooch;

class GroupModel extends ChangeNotifier {
  Group? _group;

  void reset() {
    _group = null;
  }

  set group(Group? group) {
    if (_group != group) {
      _group = group;
      debugPrint('group: ${group?.id}');
    }
  }

  Group? get group => _group;
}
