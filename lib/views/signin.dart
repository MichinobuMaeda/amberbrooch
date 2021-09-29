part of amberbrooch;

class SignInView extends StatefulWidget {
  final Conf? conf;
  final AuthModel authModel;

  const SignInView({
    Key? key,
    this.conf,
    required this.authModel,
  }) : super(key: key);

  @override
  SignInState createState() => SignInState();
}

enum SignInMethods { emailLink, emailPasrowd }

@visibleForTesting
class SignInState extends State<SignInView> {
  SignInMethods _signInMethods = SignInMethods.emailLink;
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
        FlexRow([
          const Text('ログイン方法を選択してください。'),
          RadioList<SignInMethods>(
            options: const {
              SignInMethods.emailLink: 'メールでログイン用のリンクを受け取る。',
              SignInMethods.emailPasrowd: 'メールアドレスとパスワードでログインする。',
            },
            groupValue: _signInMethods,
            onChanged: (SignInMethods? value) {
              setState(() {
                _signInMethods = value ?? SignInMethods.emailLink;
              });
            },
          ),
        ]),
        Form(
          key: _formEmailKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Wrap(children: [
            FlexRow([
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
                  autofocus: true,
                ),
              ),
              if (_signInMethods == SignInMethods.emailLink)
                Padding(
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
                          await widget.authModel.sendSignInLinkToEmail(
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
            ], alignment: WrapAlignment.end),
            if (_signInMethods == SignInMethods.emailPasrowd)
              FlexRow([
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
                          await widget.authModel.signInWithEmailAndPassword(
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
              ], alignment: WrapAlignment.end),
          ]),
        ),
        const FlexRow([
          Text('入力したメールアドレスに間違いがないかご確認ください。'),
          Text('携帯電話事業者のアドレスの場合は受信拒否の設定をご確認ください。'),
          Text('どのログイン方法でもうまくいかない場合は、管理者にご連絡ください。'),
        ]),
        if (useEmulator)
          FlexRow([
            TextButton(
              child: const Text('Test'),
              onPressed: () async {
                await widget.authModel.signInWithEmailAndPassword(
                  email: testEmail,
                  password: testPassword,
                  resetRecord: true,
                );
              },
            ),
          ])
      ],
    );
  }
}
