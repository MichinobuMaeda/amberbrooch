part of amberbrooch;

enum View { home, preferences, policy }

class ClientModel extends ChangeNotifier {
  ThemeMode _themeMode = defaultThemeMode;
  final LocalStore localStore;
  View _view = View.home;
  int _panel = 0;
  final _keyEmail = 'amberbrooch_email';
  final _keyPageName = 'amberbrooch_route_name';
  final _keyPageId = 'amberbrooch_route_item';

  ClientModel(this.localStore) {
    switch (routeName) {
      case 'preferences':
        _view = View.preferences;
        _panel = int.tryParse(routeItem) ?? 0;
        break;
      case 'policy':
        _view = View.policy;
        break;
      default:
        _view = View.home;
        break;
    }

    routeName = '';
    routeItem = '';
  }

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  set view(View view) {
    _view = view;
    notifyListeners();
  }

  View get view => _view;

  set panel(int panel) {
    _panel = panel;
    notifyListeners();
  }

  int get panel => _panel;

  set email(String value) {
    localStore.setValue(_keyEmail, value);
  }

  String get email => localStore.getValue(_keyEmail);

  set routeName(String value) {
    localStore.setValue(_keyPageName, value);
  }

  String get routeName => localStore.getValue(_keyPageName);

  set routeItem(String value) {
    localStore.setValue(_keyPageId, value);
  }

  String get routeItem => localStore.getValue(_keyPageId);
}
