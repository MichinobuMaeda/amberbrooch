library amberbrooch;

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import "package:universal_html/html.dart" as html;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

part 'conf.dart';
part 'router.dart';
part 'utils.dart';
part 'validators.dart';
part 'widgets.dart';
part 'entities/account.dart';
part 'entities/auth_user.dart';
part 'entities/base.dart';
part 'entities/conf.dart';
part 'entities/group.dart';
part 'entities/version.dart';
part 'models/accounts.dart';
part 'models/auth.dart';
part 'models/client.dart';
part 'models/conf.dart';
part 'models/groups.dart';
part 'models/firebase.dart';
part 'models/me.dart';
part 'models/group.dart';
part 'models/theme_mode.dart';
part 'models/version.dart';
part 'screens/base.dart';
part 'screens/loading.dart';
part 'screens/signin.dart';
part 'screens/verify_email.dart';
part 'screens/top.dart';
part 'screens/policy.dart';
part 'screens/preferences.dart';

void main() {
  String deepLink = html.window.location.href;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeModeModel()),
      ChangeNotifierProvider(create: (context) => ClientModel(deepLink)),
      ChangeNotifierProvider(create: (context) => FirebaseModel()),
      ChangeNotifierProvider(create: (context) => VersionModel()),
      ChangeNotifierProvider(create: (context) => ConfModel()),
      ChangeNotifierProvider(create: (context) => AuthModel(auth)),
      ChangeNotifierProvider(create: (context) => AccountsModel()),
      ChangeNotifierProvider(create: (context) => MeModel()),
      ChangeNotifierProvider(create: (context) => GroupModel()),
      ChangeNotifierProvider(create: (context) => GroupsModel()),
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
