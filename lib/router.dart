part of amberbrooch;

enum RouteName { home, preferences, policy }
Map<RouteName, String> routePath = {
  RouteName.home: '/',
  RouteName.preferences: '/preferences',
  RouteName.policy: '/policy',
};

RouteName? routeNameFromPath(String path) {
  for (RouteName routeName in RouteName.values) {
    if (path == routePath[routeName] ||
        path.startsWith('${routePath[routeName]}/')) {
      return routeName;
    }
  }
  return null;
}

class AppRoute {
  final RouteName name;
  final String? id;

  AppRoute({
    required this.name,
    this.id,
  });
  AppRoute.home()
      : name = RouteName.home,
        id = null;
  AppRoute.preferences()
      : name = RouteName.preferences,
        id = null;
  AppRoute.policy()
      : name = RouteName.policy,
        id = null;

  @override
  operator ==(Object other) =>
      other is AppRoute && other.name == name && other.id == id;

  @override
  int get hashCode => hashValues(name, id);

  @override
  String toString() {
    return 'AppRoute(name:$name,id:$id)';
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    String location = routeInformation.location ?? '';
    RouteName? name = routeNameFromPath(location);
    final uri = Uri.parse(location);
    return name == null || uri.pathSegments.isEmpty
        ? AppRoute.home()
        : uri.pathSegments.length == 1
            ? AppRoute(
                name: name,
              )
            : AppRoute(
                name: name,
                id: uri.pathSegments[1],
              );
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) {
    return RouteInformation(
        location: configuration.id == null
            ? routePath[configuration.name]
            : '${routePath[configuration.name]}/${configuration.id}');
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  late ClientModel _clientModel;
  AppRoute _route = AppRoute.home();
  String? _panel;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  set clientModel(ClientModel clientModel) {
    _clientModel = clientModel;
    _clientModel.router = this;
  }

  void goRoute(AppRoute route, {String? panel}) {
    _route = route;
    _panel = panel;
    notifyListeners();
  }

  @override
  AppRoute get currentConfiguration {
    return _route;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceModel>(
      builder: (context, service, child) {
        if (service.me != null &&
            service.user?.emailVerified == true &&
            _route.name == AppRoute.home().name) {
          _clientModel.restoreRoute(context: context);
        }
        String? panel = _panel;
        _panel = null;

        return Navigator(
          key: navigatorKey,
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            if ([RouteName.policy].contains(_route.name)) {
              _route = AppRoute.preferences();
            } else if ([RouteName.preferences].contains(_route.name)) {
              _route = AppRoute.home();
            }
            notifyListeners();
            return true;
          },
          pages: [
            // Level 1
            MaterialPage(
              key: ValueKey(AppRoute.home().toString()),
              child: HomeScreen(
                clientModel: _clientModel,
                service: service,
                route: AppRoute.home(),
              ),
            ),
            // Level 2
            if ([
              RouteName.preferences,
              RouteName.policy,
            ].contains(_route.name))
              MaterialPage(
                key: ValueKey(AppRoute.preferences().toString()),
                child: PreferencesScreen(
                  clientModel: _clientModel,
                  service: service,
                  route: AppRoute.preferences(),
                  panel: panel,
                ),
              ),
            // Level 3
            if ([
              RouteName.policy,
            ].contains(_route.name))
              MaterialPage(
                key: ValueKey(_route.toString()),
                child: PolicyScreen(
                  clientModel: _clientModel,
                  service: service,
                  route: _route,
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    _route = configuration;
  }
}
