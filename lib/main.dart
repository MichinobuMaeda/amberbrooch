library amberbrooch;

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import "package:universal_html/html.dart" as html;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'config/firebase.dart';
part 'config/theme.dart';
part 'entities/account.dart';
part 'entities/auth_user.dart';
part 'entities/base.dart';
part 'entities/conf.dart';
part 'models/auth.dart';
part 'models/firebase.dart';
part 'models/me.dart';
part 'models/client.dart';
part 'models/conf.dart';
part 'views/loading.dart';
part 'views/policy.dart';
part 'views/preferences.dart';
part 'views/scroll_view.dart';
part 'views/signin.dart';
part 'views/top.dart';
part 'views/verify_email.dart';
part 'home.dart';
part 'utils.dart';
part 'validators.dart';
part 'widgets.dart';

void main() {
  String deepLink = html.window.location.href;
  LocalStore localStore = WebClientLocalStore();
  bool useEmulator = html.window.location.href.startsWith('http://');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClientModel(localStore)),
        ChangeNotifierProvider(create: (context) => FirebaseModel(useEmulator)),
        ChangeNotifierProvider(create: (context) => AuthModel(deepLink)),
        ChangeNotifierProvider(create: (context) => ConfModel()),
        ChangeNotifierProvider(create: (context) => MeModel()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;
    final FirebaseFunctions functions =
        FirebaseFunctions.instanceFor(region: functionsRegion);

    Provider.of<FirebaseModel>(context, listen: false).listen(
      auth: auth,
      db: db,
      storage: storage,
      functions: functions,
      authModel: Provider.of<AuthModel>(context, listen: false),
      confModel: Provider.of<ConfModel>(context, listen: false),
      meModel: Provider.of<MeModel>(context, listen: false),
      clientModel: Provider.of<ClientModel>(context, listen: false),
    );

    return Consumer<ClientModel>(
      builder: (context, clientModel, child) {
        return MaterialApp(
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
          home: HomePage(clientModel: clientModel),
        );
      },
    );
  }
}
