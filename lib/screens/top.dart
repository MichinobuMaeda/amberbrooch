import 'package:flutter/material.dart';
import '../models.dart';
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
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const PageTitle(
          iconData: Icons.home,
          title: 'トップ',
        ),
        gutter,
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            PrimaryButton(
              iconData: Icons.settings,
              label: '設定',
              onPressed: () {
                widget.pushRoute(AppRoutePath.preferences());
              },
            ),
            PrimaryButton(
              iconData: Icons.policy,
              label: 'プライバシー・ポリシー',
              onPressed: () {
                widget.pushRoute(AppRoutePath.policy());
              },
            ),
          ],
        ),
      ],
    );
  }
}
