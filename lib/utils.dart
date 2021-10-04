part of amberbrooch;

Function deepCollectionEquality = const DeepCollectionEquality().equals;

abstract class LocalStore {
  void setValue(String key, String value);
  String getValue(String key);
}

class WebClientLocalStore extends LocalStore {
  @override
  String getValue(String key) {
    return html.window.localStorage[key] ?? '';
  }

  @override
  void setValue(String key, String value) {
    html.window.localStorage[key] = value;
  }
}
