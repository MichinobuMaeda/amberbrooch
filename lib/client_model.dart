part of amberbrooch;

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

class ClientModel extends ChangeNotifier {
  ThemeMode _themeMode = defaultThemeMode;
  final LocalStore localStore;
  final _keyEmail = 'amberbrooch_email';
  final _keyPageName = 'amberbrooch_route_name';
  final _keyPageId = 'amberbrooch_route_item';

  ClientModel(this.localStore);

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  set email(String value) {
    localStore.setValue(_keyEmail, value);
  }

  String get email => localStore.getValue(_keyEmail);

  void goRoute(BuildContext context, AppRoute route) {
    Navigator.pushNamed(
      context,
      route.name,
      arguments: RouteArguments(id: route.id),
    );
  }

  void storeRoute(AppRoute appRoute) {
    localStore.setValue(_keyPageName, appRoute.name);
    localStore.setValue(_keyPageId, appRoute.id ?? '');
  }

  void restoreRoute({required BuildContext context}) {
    String name = localStore.getValue(_keyPageName);
    String id = localStore.getValue(_keyPageId);
    if (name == '' || name == AppRoute.home().name) {
      return;
    }
    storeRoute(AppRoute.home());
    Timer(
      const Duration(milliseconds: 500),
      () => goRoute(context, AppRoute(name: name, id: id == '' ? null : id)),
    );
  }

  void realoadApp() {
    html.window.location.reload();
  }
}
