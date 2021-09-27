part of amberbrooch;

class VerifyEmailScreen extends BaseScreen {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  VerifyEmailState createState() => VerifyEmailState();
}

@visibleForTesting
class VerifyEmailState extends BaseState {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
    AuthUser? authUser = authModel.user;

    return AppLayout(
      appOutdated: appOutdated(context),
      children: [
        const PageTitle(
          iconData: Icons.email,
          title: 'メールアドレスの確認',
        ),
        FlexRow([
          Text(
            '確認のためのメールを ${authUser?.email} に送信します。「送信」ボタンを押してください。',
          ),
        ]),
        FlexRow([
          PrimaryButton(
            iconData: Icons.send,
            label: '送信',
            onPressed: () async {
              try {
                await auth.currentUser!.sendEmailVerification();
                _timer = Timer.periodic(
                  const Duration(seconds: 1),
                  (timer) async {
                    await authModel.reload();
                    AuthUser? authUser = authModel.user;
                    if (authUser?.emailVerified == true) {
                      _timer?.cancel();
                      _timer = null;
                    }
                  },
                );
                showNotificationSnackBar(
                  context: context,
                  message: '確認のためのメールを ${authUser?.email} に送信しました。'
                      '受信したメールの確認のためのリンクをクリックしてください。',
                );
              } catch (e) {
                showNotificationSnackBar(
                  context: context,
                  message: 'メール送信の処理でエラーになりました。'
                      'やり直しても解決しない場合は管理者にお伝えください。',
                );
              }
            },
          ),
        ]),
        const FlexRow([
          Text(
            'メールが届かない場合は念のためメールアドレスをご確認ください。'
            '携帯電話事業者のアドレスの場合は受信拒否の設定をご確認ください。',
          )
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
      ],
    );
  }
}
