import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('entities/clientModel: initialized with defaultThemeMode', () {
    ClientModel clientModel = ClientModel(WebClientLocalStore());
    expect(clientModel.themeMode, defaultThemeMode);
  });
  test('entities/clientModel: can get/set mode.', () {
    ThemeMode themeMode = ThemeMode.dark;
    ClientModel clientModel = ClientModel(WebClientLocalStore());
    clientModel.themeMode = themeMode;
    expect(clientModel.themeMode, themeMode);
    expect(clientModel.themeMode == defaultThemeMode, false);
  });
}
