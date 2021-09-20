import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../conf.dart';
import '../router.dart';
import '../models.dart';
import '../widgets.dart';

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
    Conf? conf = Provider.of<ConfModel>(context, listen: false).conf;
    PackageInfo? packageInfo =
        Provider.of<ClientModel>(context, listen: false).packageInfo;
    appOutdated = conf != null &&
        packageInfo != null &&
        (conf.version != packageInfo.version ||
            conf.buildNumber != packageInfo.buildNumber);

    return Scaffold(
      appBar: Header(
        context: context,
        pushRoute: widget.pushRoute,
        appTitle: appTitle,
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - kToolbarHeight,
            ),
            child: buildBody(context, constraints),
          ),
        );
      }),
    );
  }
}
