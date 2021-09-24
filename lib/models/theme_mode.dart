part of amberbrooch;

class ThemeModeModel extends ChangeNotifier {
  ThemeMode _mode = defaultThemeMode;

  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }

  ThemeMode get mode => _mode;
}
