part of amberbrooch;

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
        realoadApp: realoadApp,
      ),
      FlexRow([
        Text(
          '確認のためのメールを ${authUser?.email} に送信します。「送信」ボタンを押してください。',
        ),
      ]),
      if (_sendVerificationMail)
        FlexRow([
          Text(
            '確認のためのメールを ${authUser?.email} に送信しました。'
            '受信したメールの確認のためのリンクをクリックしてください。',
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
