import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../conf.dart';
import '../widgets.dart';
import '../models.dart';
import '../router.dart';
import 'base.dart';

class PreferencesPage extends Page {
  final ValueChanged<AppRoutePath> pushRoute;

  const PreferencesPage({
    required this.pushRoute,
  }) : super(key: const ValueKey('PreferencesPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) =>
          PreferencesScreen(pushRoute: pushRoute),
    );
  }
}

class PreferencesScreen extends BaseScreen {
  const PreferencesScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends BaseState {
  @override
  Widget buildBody(BuildContext context, BoxConstraints constraints) {
    ClientModel clientModel = Provider.of<ClientModel>(context, listen: false);
    ThemeModeModel themeModeModel = Provider.of<ThemeModeModel>(context);
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    AuthUser? authUser = authModel.getUser();
    List<ThemeMode> themeModes = [
      ThemeMode.light,
      ThemeMode.dark,
      ThemeMode.system,
    ];

    return ContentBody([
      const PageTitle(
        iconData: Icons.settings,
        title: 'アプリの情報と設定',
      ),
      FlexRow([
        PrimaryButton(
          iconData: Icons.policy,
          label: 'プライバシー・ポリシー',
          onPressed: () {
            widget.pushRoute(AppRoutePath.policy());
          },
        ),
        ShowAboutButton(
          context: context,
          appTitle: appTitle,
          packageInfo: clientModel.packageInfo,
        ),
      ]),
      FlexRow([
        const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text('表示モード'),
        ),
        ToggleButtons(
          children: const [
            Icon(Icons.light_mode),
            Icon(Icons.dark_mode),
            Text('自動'),
          ],
          onPressed: (int index) {
            setState(() {
              themeModeModel.mode = themeModes[index];
            });
          },
          isSelected: [
            themeModeModel.mode == themeModes[0],
            themeModeModel.mode == themeModes[1],
            themeModeModel.mode == themeModes[2],
          ],
        ),
      ]),
      FlexRow((authUser != null
          ? [
              PrimaryButton(
                iconData: Icons.logout,
                label: 'ログアウト',
                onPressed: () async {
                  await auth.signOut();
                  widget.pushRoute(AppRoutePath.top());
                },
              ),
            ]
          : [])),
    ]);
  }
}
