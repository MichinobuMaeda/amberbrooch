part of amberbrooch;

abstract class BaseScreen extends StatefulWidget {
  final ClientModel clientModel;
  final ServiceModel service;
  final AppRoute route;

  const BaseScreen({
    Key? key,
    required this.clientModel,
    required this.service,
    required this.route,
  }) : super(key: key);
}

Scaffold scaffoldApp({
  required ClientModel clientModel,
  required ServiceModel service,
  required AppRoute route,
  required Widget child,
}) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(40.0),
      child: AppBar(
        title: const Text(appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: route.name == AppRoute.preferences().name
                ? null
                : () {
                    clientModel.goRoute(AppRoute.preferences());
                  },
          )
        ],
      ),
    ),
    body: Stack(
      children: [
        child,
        Visibility(
          visible: service.conf != null && version != service.conf?.version,
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
                  clientModel.realoadApp();
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: service.conf == null,
          child: const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: fontSizeBody * 2,
                horizontal: fontSizeBody / 2,
              ),
              child: Text(version),
            ),
          ),
        ),
      ],
    ),
  );
}
