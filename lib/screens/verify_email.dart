import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';
import 'base.dart';

class VerifyEmailScreen extends BaseScreen {
  const VerifyEmailScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends BaseState {
  Timer? _timer;
  bool _sendVerificationMail = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context, BoxConstraints constraints) {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    AuthUser? authUser = authModel.user;

    return ContentBody([
      PageTitle(
        iconData: Icons.email,
        title: 'メールアドレスの確認',
        appOutdated: appOutdated,
      ),
      FlexRow([
        Text(
          '確認のためのメールを ${authUser?.email} に' +
              (_sendVerificationMail
                  ? '送信しました。受信したメールの確認のためのリンクをクリックしてください。'
                  : '送信します。「送信」ボタンを押してください。'),
        ),
      ]),
      FlexRow([
        PrimaryButton(
          iconData: Icons.send,
          label: '送信',
          onPressed: () {
            auth.currentUser!.sendEmailVerification();
            setState(() {
              _sendVerificationMail = true;
            });
            _timer = Timer.periodic(
              const Duration(seconds: 1),
              (timer) async {
                await authModel.reload();
                AuthUser? authUser = authModel.user;
                // debugPrint('${authUser?.emailVerified}');
                if (authUser?.emailVerified == true) {
                  _timer?.cancel();
                  _timer = null;
                }
              },
            );
          },
        ),
      ]),
      const FlexRow([
        Text('やり直す場合はログアウトしてください。'),
      ]),
      FlexRow([
        PrimaryButton(
          iconData: Icons.logout,
          label: 'ログアウト',
          onPressed: () async {
            await auth.signOut();
          },
        ),
      ]),
    ]);
  }
}
