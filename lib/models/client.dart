part of amberbrooch;

enum View { home, settings, policy }

class ClientModel extends ChangeNotifier {
  ThemeMode _themeMode = defaultThemeMode;
  View _view = View.home;

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
}
