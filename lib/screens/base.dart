part of amberbrooch;

abstract class BaseScreen extends StatefulWidget {
  final ValueChanged<AppRoutePath> pushRoute;

  const BaseScreen({
    Key? key,
    required this.pushRoute,
  }) : super(key: key);

  @override
  BaseState createState();
}

abstract class BaseState extends State<BaseScreen> {
  Widget buildBody(BuildContext context, BoxConstraints constraints);
  bool appOutdated = false;

  @override
  Widget build(BuildContext context) {
    Version? ver = Provider.of<VersionModel>(context, listen: false).version;
    PackageInfo? packageInfo =
        Provider.of<ClientModel>(context, listen: false).packageInfo;
    appOutdated = ver != null &&
        packageInfo != null &&
        (ver.version != packageInfo.version ||
            ver.buildNumber != packageInfo.buildNumber);

    return Scaffold(
      appBar: Header(
        context: context,
        pushRoute: widget.pushRoute,
        appTitle: appTitle,
      ),
      body: LayoutBuilder(builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - kToolbarHeight,
                maxWidth: maxContentBodyWidth,
              ),
              child: buildBody(context, constraints),
            ),
          ),
        );
      }),
    );
  }
}
