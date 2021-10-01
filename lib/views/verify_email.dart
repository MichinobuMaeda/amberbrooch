part of amberbrooch;

class VerifyEmailView extends StatefulWidget {
  final AuthModel authModel;

  const VerifyEmailView({
    Key? key,
    required this.authModel,
  }) : super(key: key);

  @override
  VerifyEmailState createState() => VerifyEmailState();
}

@visibleForTesting
class VerifyEmailState extends State<VerifyEmailView> {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageTitle(
          iconData: Icons.email,
          title: 'メールアドレスの確認',
        ),
        FlexRow(
          children: [
            Text(
              '確認のためのメールを ${authUser?.email} に送信します。「送信」ボタンを押してください。',
            ),
          ],
        ),
        FlexRow(
          children: [
            PrimaryButton(
              iconData: Icons.send,
              label: '送信',
              onPressed: () async {
                try {
                  await widget.authModel.sendEmailVerification();
                  _timer = Timer.periodic(
                    const Duration(seconds: 1),
                    (timer) async {
                      await authModel.reload();
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
          ],
        ),
        const FlexRow(
          children: [
            Text(
              'メールが届かない場合は念のためメールアドレスをご確認ください。'
              '携帯電話事業者のアドレスの場合は受信拒否の設定をご確認ください。',
            )
          ],
        ),
        const FlexRow(
          children: [
            Text('やり直す場合はログアウトしてください。'),
          ],
        ),
        FlexRow(
          children: [
            PrimaryButton(
              iconData: Icons.logout,
              label: 'ログアウト',
              onPressed: () async {
                await widget.authModel.signOut();
              },
            ),
          ],
        ),
      ],
    );
  }
}
