import 'package:flutter/material.dart';
import '../widgets.dart';
import '../router.dart';
import 'base.dart';

class PolicyPage extends Page {
  final ValueChanged<AppRoutePath> pushRoute;

  const PolicyPage({
    required this.pushRoute,
  }) : super(key: const ValueKey('PolicyPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => PolicyScreen(pushRoute: pushRoute),
    );
  }
}

class PolicyScreen extends BaseScreen {
  const PolicyScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _PolicyState createState() => _PolicyState();
}

class _PolicyState extends BaseState {
  @override
  Widget buildBody(BuildContext context, BoxConstraints constraints) {
    return ContentBody([
      PageTitle(
        iconData: Icons.policy,
        title: 'プライバシー・ポリシー',
        appOutdated: appOutdated,
      ),
    ]);
  }
}
