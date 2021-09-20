import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'screens/loading.dart';
import 'screens/signin.dart';
import 'screens/verify_email.dart';
import 'screens/top.dart';
import 'screens/policy.dart';
import 'screens/preferences.dart';

class AppRoutePath {
  final String name;
  final String? id;

  AppRoutePath.top()
      : name = '',
        id = null;

  AppRoutePath.policy()
      : name = 'policy',
        id = null;

  AppRoutePath.preferences()
      : name = 'preferences',
        id = null;

  static AppRoutePath getRoutePathByName({
    required String name,
    String? id,
  }) {
    switch (name) {
      case 'policy':
        return AppRoutePath.policy();
      case 'preferences':
        return AppRoutePath.preferences();
      default:
        return AppRoutePath.top();
    }
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    String location = routeInformation.location ?? '';
    final uri = Uri.parse(location);

    switch (uri.pathSegments.length) {
      case 1:
        return AppRoutePath.getRoutePathByName(
          name: uri.pathSegments[0],
        );
      case 2:
        return AppRoutePath.getRoutePathByName(
          name: uri.pathSegments[0],
          id: uri.pathSegments[1],
        );
      default:
        return AppRoutePath.top();
    }
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    return configuration.id == null
        ? RouteInformation(
            location: '/${configuration.name}',
          )
        : RouteInformation(
            location: '/${configuration.name}/${configuration.id}',
          );
  }
}

enum AppState { loading, guest, verifying, authenticated }

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  AppState _state = AppState.loading;
  String _name = AppRoutePath.top().name;
  String? _id;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  void _handlePush(AppRoutePath path) {
    _name = path.name;
    _id = path.id;
    notifyListeners();
  }

  @override
  AppRoutePath get currentConfiguration =>
      AppRoutePath.getRoutePathByName(name: _name, id: _id);

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    if (_state == AppState.authenticated ||
        configuration.name == AppRoutePath.policy().name) {
      _name = configuration.name;
      _id = configuration.id;
    } else {
      _name = AppRoutePath.top().name;
      _id = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfModel>(
      builder: (context, confModel, child) {
        return Consumer<AuthModel>(
          builder: (context, authModel, child) {
            AuthUser? authUser = authModel.user;

            if (!confModel.initialized) {
              _state = AppState.loading;
            } else if (authUser == null) {
              _state = AppState.guest;
            } else if (authUser.email != null &&
                authUser.emailVerified != true) {
              _state = AppState.verifying;
            } else {
              _state = AppState.authenticated;
            }

            return Navigator(
              key: navigatorKey,
              pages: [
                MaterialPage(
                  key: const ValueKey('HomePage'),
                  child: _state == AppState.authenticated
                      ? TopScreen(pushRoute: _handlePush)
                      : (_state == AppState.verifying
                          ? VerifyEmailScreen(pushRoute: _handlePush)
                          : (_state == AppState.guest
                              ? SignInScreen(pushRoute: _handlePush)
                              : LoadingScreen(pushRoute: _handlePush))),
                ),
                if (_name == AppRoutePath.preferences().name ||
                    _name == AppRoutePath.policy().name)
                  PreferencesPage(pushRoute: _handlePush),
                if (_name == AppRoutePath.policy().name)
                  PolicyPage(pushRoute: _handlePush)
              ],
              onPopPage: (route, result) {
                if (!route.didPop(result)) {
                  return false;
                }

                if (_name == AppRoutePath.policy().name) {
                  _name = AppRoutePath.preferences().name;
                  _id = null;
                } else {
                  _name = AppRoutePath.top().name;
                  _id = null;
                }

                notifyListeners();

                return true;
              },
            );
          },
        );
      },
    );
  }
}
