part of amberbrooch;

class SigninView extends StatefulWidget {
  final Conf? conf;
  final ClientModel clientModel;
  final ServiceModel service;

  const SigninView({
    Key? key,
    this.conf,
    required this.clientModel,
    required this.service,
  }) : super(key: key);

  @override
  _SigninViewState createState() => _SigninViewState();
}

enum SigninMethods { emailLink, emailPasrowd }

class _SigninViewState extends State<SigninView> {
  SigninMethods _signInMethods = SigninMethods.emailLink;
  final GlobalKey<FormState> _formEmailKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(
    text: '',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '',
  );
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Conf? conf = widget.conf;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageTitle(
          iconData: Icons.login,
          title: 'ログイン',
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            child: const Text('プライバシー・ポリシー'),
            onPressed: () {
              widget.clientModel.goRoute(AppRoute.policy());
            },
          ),
        ),
        FlexRow(
          children: [
            const Text('ログイン方法を選択してください。'),
            RadioList<SigninMethods>(
              options: const {
                SigninMethods.emailLink: 'メールでログイン用のリンクを受け取る。',
                SigninMethods.emailPasrowd: 'メールアドレスとパスワードでログインする。',
              },
              groupValue: _signInMethods,
              onChanged: (SigninMethods? value) {
                setState(() {
                  _signInMethods = value ?? SigninMethods.emailLink;
                });
              },
            ),
          ],
        ),
        Form(
          key: _formEmailKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Wrap(children: [
            FlexRow(
              alignment: WrapAlignment.end,
              children: [
                SizedBox(
                  width: maxContentBodyWidth / 2,
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(fontFamily: fontFamilyMonoSpace),
                    decoration: const InputDecoration(
                      label: Text('メールアドレス'),
                    ),
                    validator: (String? value) => validateRequired(value)
                        ? (validateEmail(value)
                            ? null
                            : '正しい書式のメールアドレスを記入してください。')
                        : 'メールアドレスを記入してください。',
                  ),
                ),
                Visibility(
                  visible: _signInMethods == SigninMethods.emailLink,
                  child: Padding(
                    padding: const EdgeInsets.only(top: fontSizeBody),
                    child: SendMailButton(
                      onPressed: () async {
                        String email = _emailController.text;
                        if (!_formEmailKey.currentState!.validate()) {
                          showNotificationSnackBar(
                            context: context,
                            message: '入力エラーがあります。',
                          );
                        } else {
                          try {
                            await widget.service.sendSignInLinkToEmail(
                              email: email,
                              url: conf!.url,
                            );
                            showNotificationSnackBar(
                              context: context,
                              durationMilliSec: 10 * 1000,
                              message: 'ログイン用のリンクを $email に送信しました。'
                                  '受信したメールのリンクをクリックしてください。',
                            );
                          } catch (e) {
                            showNotificationSnackBar(
                              context: context,
                              message: 'メール送信の処理でエラーになりました。'
                                  'やり直しても解決しない場合は管理者にお伝えください。',
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            FlexRow(
              alignment: WrapAlignment.end,
              visible: _signInMethods == SigninMethods.emailPasrowd,
              children: [
                SizedBox(
                  width: maxContentBodyWidth / 2,
                  child: TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(fontFamily: fontFamilyMonoSpace),
                    obscureText: !_passwordVisible,
                    validator: (String? value) =>
                        validateRequired(value) ? null : 'パスワードを記入してください。',
                    decoration: InputDecoration(
                      label: const Text('パスワード'),
                      suffixIcon: VisibilityIconButton(
                        visible: _passwordVisible,
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: fontSizeBody),
                  child: PrimaryButton(
                    iconData: Icons.lock_open,
                    label: 'ログイン',
                    onPressed: () async {
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      if (!_formEmailKey.currentState!.validate()) {
                        showNotificationSnackBar(
                          context: context,
                          message: '入力エラーがあります。',
                        );
                      } else {
                        try {
                          await widget.service.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                        } catch (e) {
                          showNotificationSnackBar(
                            context: context,
                            message: 'ログインの処理でエラーになりました。'
                                'メールアドレスとパスワードを確認してください。'
                                'やり直しても解決しない場合は管理者にお伝えください。',
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ]),
        ),
        const FlexRow(
          children: [
            Text('入力したメールアドレスに間違いがないかご確認ください。'),
            Text('携帯電話事業者のアドレスの場合は受信拒否の設定をご確認ください。'),
            Text('どのログイン方法でもうまくいかない場合は、管理者にご連絡ください。'),
          ],
        ),
        Visibility(
          visible: widget.service.useEmulator,
          child: FlexRow(
            children: [
              TextButton(
                child: const Text('Test'),
                onPressed: () async {
                  await widget.service.signInWithEmailAndPassword(
                    email: testEmail,
                    password: testPassword,
                    resetRecord: true,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
