import 'package:flutter/material.dart';
import '../conf.dart';
import '../widgets.dart';
import '../router.dart';
import 'base.dart';

class TopScreen extends BaseScreen {
  const TopScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _TopState createState() => _TopState();
}

class _TopState extends BaseState {
  @override
  Widget buildBody(BuildContext context, BoxConstraints constraints) {
    return ContentBody([
      PageTitle(
        iconData: Icons.home,
        title: appTitle,
        appOutdated: appOutdated,
      ),
      FlexRow([
        PrimaryButton(
          iconData: Icons.settings,
          label: 'アプリの情報と設定',
          onPressed: () {
            widget.pushRoute(AppRoutePath.preferences());
          },
        ),
      ]),
    ]);
  }
}
