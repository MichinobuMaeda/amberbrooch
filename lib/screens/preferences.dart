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
  Widget buildBody(BuildContext context) {
    ThemeModeModel themeModeModel = Provider.of<ThemeModeModel>(context);
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    AuthUser? authUser = authModel.getUser();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
            const PageTitle(
              iconData: Icons.settings,
              title: '設定',
            ),
            gutter,
            Row(children: [
              returnButton,
            ]),
            gutter,
            DropdownButton<ThemeMode>(
              value: themeModeModel.mode,
              onChanged: (ThemeMode? value) {
                themeModeModel.mode = value ?? defaultThemeMode;
              },
              items: const [
                DropdownMenuItem<ThemeMode>(
                  value: ThemeMode.light,
                  child: Text('ライトモード'),
                ),
                DropdownMenuItem<ThemeMode>(
                  value: ThemeMode.dark,
                  child: Text('ダークモード'),
                ),
                DropdownMenuItem<ThemeMode>(
                  value: ThemeMode.system,
                  child: Text('システムの設定に従う'),
                ),
              ],
            ),
          ] +
          (authUser != null
              ? [
                  gutter,
                  PrimaryButton(
                    iconData: Icons.logout,
                    label: 'ログアウト',
                    onPressed: () {
                      widget.pushRoute(AppRoutePath.top());
                      auth.signOut();
                    },
                  ),
                ]
              : []),
    );
  }
}
