part of amberbrooch;

Function deepCollectionEquality = const DeepCollectionEquality().equals;

void realoadApp() {
  html.window.location.reload();
}

class LocalStorage {
  final _keyEmail = 'amberbrooch_email';
  final _keyPageName = 'amberbrooch_page_name';
  final _keyPageId = 'amberbrooch_page_id';

  set email(String value) {
    _setValue(_keyEmail, value);
  }

  String get email => _getValue(_keyEmail);

  set pageName(String value) {
    _setValue(_keyPageName, value);
  }

  String get pageName => _getValue(_keyPageName);

  set pageId(String value) {
    _setValue(_keyPageId, value);
  }

  String get pageId => _getValue(_keyPageId);

  _setValue(String key, String value) {
    html.window.localStorage[key] = value;
  }

  String _getValue(String key) => html.window.localStorage[key] ?? '';
}
