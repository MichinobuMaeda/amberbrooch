part of amberbrooch;

class SignInScreen extends BaseScreen {
  const SignInScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends BaseState {
  final GlobalKey<FormState> _formKeyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> _keyPassword = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool passwordVisible = false;
  bool _sendEmailLink = false;
  bool _errorEmailLink = false;
  bool _errorEmailAndPassword = false;

  @override
  Widget buildBody(BuildContext context, BoxConstraints constraints) {
    ConfModel confModel = Provider.of<ConfModel>(context, listen: false);
    Conf? conf = confModel.conf;

    return ContentBody([
      PageTitle(
        iconData: Icons.login,
        title: 'ログイン',
        appOutdated: appOutdated,
        realoadApp: realoadApp,
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
      Form(
          key: _formKeyEmail,
          autovalidateMode: AutovalidateMode.always,
          child: Wrap(children: [
            FlexRow([
              SizedBox(
                width: maxContentBodyWidth / 2,
                child: TextFormField(
                  key: _keyEmail,
                  initialValue: _email,
                  decoration: const InputDecoration(
                    label: Text('メールアドレス'),
                  ),
                  validator: (String? value) =>
                      validateEmail(value) ? null : '正しい書式のメールアドレスを記入してください。',
                  onChanged: (String? value) {
                    setState(() {
                      _email = value ?? '';
                      _sendEmailLink = false;
                      _errorEmailLink = false;
                      _errorEmailAndPassword = false;
                    });
                  },
                  autofocus: true,
                ),
              ),
              PrimaryButton(
                iconData: Icons.email,
                label: 'メールでログイン用のリンクを受け取る',
                disabled: !(validateRequired(_email) && validateEmail(_email)),
                onPressed: () async {
                  try {
                    await auth.sendSignInLinkToEmail(
                      email: _email ?? '',
                      actionCodeSettings: ActionCodeSettings(
                        url: conf!.url,
                        handleCodeInApp: true,
                      ),
                    );
                    html.window.localStorage['amberbrooch_email'] =
                        _email ?? '';
                    setState(() {
                      _sendEmailLink = true;
                    });
                  } catch (e) {
                    setState(() {
                      _errorEmailLink = true;
                    });
                  }
                },
              ),
            ], alignment: WrapAlignment.end),
            FlexRow(_errorEmailLink
                ? [
                    Text(
                      'エラー：メールアドレスを確認してください。うまくいかない場合は管理者に連絡してください。',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    )
                  ]
                : _sendEmailLink
                    ? [
                        const Text(kIsWeb
                            ? 'ログイン用のリンクを記載したメールを送信しました。このページを閉じてください。'
                            : 'ログイン用のリンクを記載したメールを送信しました。')
                      ]
                    : []),
            FlexRow([
              SizedBox(
                width: maxContentBodyWidth / 2,
                child: TextFormField(
                  key: _keyPassword,
                  initialValue: _password,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    label: const Text('パスワード'),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _password = value ?? '';
                      _sendEmailLink = false;
                      _errorEmailLink = false;
                      _errorEmailAndPassword = false;
                    });
                  },
                ),
              ),
              PrimaryButton(
                iconData: Icons.lock_open,
                label: 'メールアドレスとパスワードでログイン',
                disabled: !(validateRequired(_email) &&
                    validateEmail(_email) &&
                    validateRequired(_password)),
                onPressed: () async {
                  try {
                    await auth.signInWithEmailAndPassword(
                      email: _email ?? '',
                      password: _password ?? '',
                    );
                  } catch (e) {
                    setState(() {
                      _errorEmailAndPassword = true;
                    });
                  }
                },
              ),
            ], alignment: WrapAlignment.end),
            FlexRow(_errorEmailAndPassword
                ? [
                    Text(
                      'エラー：メールアドレスとパスワードを確認してください。うまくいかない場合は管理者に連絡してください。',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    )
                  ]
                : []),
          ])),
      if (useEmulator)
        FlexRow([
          TextButton(
            child: const Text('Test'),
            onPressed: () async {
              await auth.signInWithEmailAndPassword(
                email: testEmail,
                password: testPassword,
              );
            },
          ),
        ])
    ]);
  }
}
