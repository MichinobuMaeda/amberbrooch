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
  bool appOutdated(BuildContext context) {
    Version? ver = Provider.of<VersionModel>(context, listen: false).version;
    PackageInfo? packageInfo =
        Provider.of<ClientModel>(context, listen: false).packageInfo;
    return ver != null &&
        packageInfo != null &&
        (ver.version != packageInfo.version ||
            ver.buildNumber != packageInfo.buildNumber);
  }
}
