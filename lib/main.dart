library amberbrooch;

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'config/version.dart';

import "package:universal_html/html.dart" as html;

part 'config/firebase.dart';
part 'config/theme.dart';
part 'entities/account.dart';
part 'entities/auth_user.dart';
part 'entities/base.dart';
part 'entities/conf.dart';
part 'views/accounts.dart';
part 'views/display_name.dart';
part 'screens/home.dart';
part 'screens/policy.dart';
part 'screens/preferences.dart';
part 'views/scroll_view.dart';
part 'views/signin.dart';
part 'views/signin_methods.dart';
part 'views/theme_mode.dart';
part 'views/top.dart';
part 'views/verify_email.dart';
part 'widgets/buttons.dart';
part 'widgets/fixedtitlesview.dart';
part 'widgets/interactions.dart';
part 'widgets/layout.dart';
part 'widgets/selects.dart';
part 'screens/base.dart';
part 'client_model.dart';
part 'router.dart';
part 'service_model.dart';
part 'validators.dart';

void main() {
  String deepLink = html.window.location.href;
  LocalStore localStore = WebClientLocalStore();
  bool useEmulator = html.window.location.href.startsWith('http://');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClientModel(localStore)),
        ChangeNotifierProvider(
          create: (context) => ServiceModel(
            useEmulator: useEmulator,
            deepLink: deepLink,
          ),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouterDelegate _routerDelegate = AppRouterDelegate();
  final AppRouteInformationParser _routeInformationParser =
      AppRouteInformationParser();

  @override
  void initState() {
    super.initState();
    Provider.of<ServiceModel>(context, listen: false).listen(
      auth: FirebaseAuth.instance,
      db: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance,
      functions: FirebaseFunctions.instanceFor(region: functionsRegion),
      clientModel: Provider.of<ClientModel>(context, listen: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientModel>(
      builder: (context, clientModel, child) {
        _routerDelegate.clientModel = clientModel;

        return MaterialApp.router(
          title: appTitle,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: primarySwatchLight,
            fontFamily: fontFamilySansSerif,
            textTheme: textTheme,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: primarySwatchDark,
            fontFamily: fontFamilySansSerif,
            textTheme: textTheme,
          ),
          themeMode: clientModel.themeMode,
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeInformationParser,
        );
      },
    );
  }
}
