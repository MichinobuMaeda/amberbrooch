import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import "package:universal_html/html.dart";
import 'conf.dart';
import 'router.dart';
import 'models.dart';

void main() {
  String deepLink = window.location.href;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeModeModel()),
      ChangeNotifierProvider(
          create: (context) => ClientModel(deepLink: deepLink)),
      ChangeNotifierProvider(create: (context) => FirebaseModel()),
      ChangeNotifierProvider(create: (context) => ConfModel()),
      ChangeNotifierProvider(create: (context) => AuthModel(auth)),
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  final AppRouterDelegate _routerDelegate = AppRouterDelegate();
  final AppRouteInformationParser _routeInformationParser =
      AppRouteInformationParser();

  App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeModel>(
      builder: (context, themeMode, child) {
        return MaterialApp.router(
          title: appTitle,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: themeMode.mode,
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeInformationParser,
        );
      },
    );
  }
}
