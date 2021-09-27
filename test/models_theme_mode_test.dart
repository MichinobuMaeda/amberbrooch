import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('entities/ThemeModeModel: initialized with defaultThemeMode', () {
    ThemeModeModel themeModeModel = ThemeModeModel();
    expect(themeModeModel.mode, defaultThemeMode);
  });
  test('entities/ThemeModeModel: can get/set mode.', () {
    ThemeMode themeMode = ThemeMode.dark;
    ThemeModeModel themeModeModel = ThemeModeModel();
    themeModeModel.mode = themeMode;
    expect(themeModeModel.mode, themeMode);
    expect(themeModeModel.mode == defaultThemeMode, false);
  });
}
