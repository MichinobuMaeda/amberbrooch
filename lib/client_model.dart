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
  late AppRouterDelegate router;
  final LocalStore localStore;
  final _keyEmail = 'amberbrooch_email';
  final _keyPageName = 'amberbrooch_route_name';
  final _keyPageId = 'amberbrooch_route_item';
  final _keyPanel = 'amberbrooch_panel';
  ThemeMode _themeMode = defaultThemeMode;

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

  void goRoute(AppRoute route, {String? panel}) {
    router.goRoute(route, panel: panel);
  }

  void storeRoute(AppRoute appRoute, {String? panel}) {
    localStore.setValue(_keyPageName, routePath[appRoute.name]!);
    localStore.setValue(_keyPageId, appRoute.id ?? '');
    localStore.setValue(_keyPanel, panel ?? '');
  }

  void restoreRoute({required BuildContext context}) {
    RouteName? name = routeNameFromPath(localStore.getValue(_keyPageName));
    String id = localStore.getValue(_keyPageId);
    String panel = localStore.getValue(_keyPanel);

    if (name == null || name == AppRoute.home().name) {
      return;
    }
    storeRoute(AppRoute.home());
    Timer(
      const Duration(milliseconds: 500),
      () => goRoute(
        AppRoute(name: name, id: id == '' ? null : id),
        panel: panel == '' ? null : panel,
      ),
    );
  }

  void realoadApp() {
    html.window.location.reload();
  }
}
