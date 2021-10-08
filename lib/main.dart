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
import 'package:flutter_markdown/flutter_markdown.dart';
import 'config/version.dart';

import "package:universal_html/html.dart" as html;

part 'config/firebase.dart';
part 'config/theme.dart';
part 'entities/account.dart';
part 'entities/auth_user.dart';
part 'entities/base.dart';
part 'entities/conf.dart';
part 'service_model.dart';
part 'client_model.dart';
part 'views/loading.dart';
part 'views/policy.dart';
part 'views/preferences.dart';
part 'views/scroll_view.dart';
part 'views/signin.dart';
part 'views/top.dart';
part 'views/verify_email.dart';
part 'widgets/buttons.dart';
part 'widgets/interactions.dart';
part 'widgets/layout.dart';
part 'widgets/selects.dart';
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

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;
    final FirebaseFunctions functions =
        FirebaseFunctions.instanceFor(region: functionsRegion);

    Provider.of<ServiceModel>(context, listen: false).listen(
      auth: auth,
      db: db,
      storage: storage,
      functions: functions,
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
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            AppRoute route = AppRoute.fromSettings(settings);
            debugPrint('route: ${route.name}:${route.id}');
            return MaterialPageRoute(
              builder: (context) {
                return AppScreen(
                  key: ValueKey('${route.name}:${route.id}'),
                  clientModel: clientModel,
                  route: route,
                );
              },
            );
          },
        );
      },
    );
  }
}

class AppRoute {
  final String name;
  final String id;

  AppRoute({
    required this.name,
    required this.id,
  });
  AppRoute.fromSettings(RouteSettings settings)
      : name = settings.name ?? AppRoute.home().name,
        id = (settings.arguments as RouteArguments?)?.id ?? '';
  AppRoute.home()
      : name = '/',
        id = '';
  AppRoute.policy()
      : name = '/policy',
        id = '';
  AppRoute.preferences({
    this.id = '0',
  }) : name = '/preferences';
}

class RouteArguments {
  final String id;
  RouteArguments({required this.id});
}

class AppScreen extends StatefulWidget {
  final ClientModel clientModel;
  final AppRoute route;

  const AppScreen({
    Key? key,
    required this.clientModel,
    required this.route,
  }) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<AppScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceModel>(
      builder: (context, service, child) {
        ClientModel clientModel =
            Provider.of<ClientModel>(context, listen: false);
        if (service.me != null &&
            service.user?.emailVerified == true &&
            widget.route.name == AppRoute.home().name) {
          clientModel.restoreRoute(context: context);
        }

        Map<String, Widget> routes = {
          AppRoute.home().name: LoadingView(
            service: service,
            child: service.me == null
                ? ScrollView(
                    child: SignInView(
                      conf: service.conf,
                      clientModel: clientModel,
                      service: service,
                    ),
                  )
                : service.user?.emailVerified == false
                    ? ScrollView(
                        child: VerifyEmailView(
                          service: service,
                        ),
                      )
                    : const TopView(),
          ),
          AppRoute.preferences().name: ScrollView(
            child: PreferencesView(
              clientModel: clientModel,
              service: service,
              routeId: widget.route.id,
            ),
          ),
          AppRoute.policy().name: ScrollView(
            child: PolicyView(
              service: service,
            ),
          ),
        };

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: AppBar(
              title: const Text(appTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: widget.route.name == AppRoute.preferences().name
                      ? null
                      : () {
                          clientModel.goRoute(
                            context,
                            AppRoute.preferences(),
                          );
                        },
                )
              ],
            ),
          ),
          body: Stack(
            children: [
              routes[widget.route.name]!,
              Visibility(
                visible: version != service.conf?.version,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: fontSizeBody * 2,
                      horizontal: fontSizeBody / 2,
                    ),
                    child: DangerButton(
                      iconData: Icons.system_update,
                      label: 'アプリを更新してください',
                      onPressed: () {
                        widget.clientModel.realoadApp();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
