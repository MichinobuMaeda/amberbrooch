import 'package:flutter/material.dart';
import '../conf.dart';
import '../models.dart';
import '../widgets.dart';
import '../router.dart';
import 'base.dart';

class SignInScreen extends BaseScreen {
  const SignInScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends BaseState {
  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
            const PageTitle(
              iconData: Icons.login,
              title: 'ログイン',
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
          ] +
          (useEmulator
              ? [
                  gutter,
                  TextButton(
                    child: const Text('Test'),
                    onPressed: () => auth.signInWithEmailAndPassword(
                      email: testEmail,
                      password: testPassword,
                    ),
                  ),
                ]
              : []),
    );
  }
}
