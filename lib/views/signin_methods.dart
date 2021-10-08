part of amberbrooch;

@visibleForTesting
class SigninMethodsView extends StatefulWidget {
  final ServiceModel service;
  final ClientModel clientModel;
  final AppRoute route;

  const SigninMethodsView({
    Key? key,
    required this.clientModel,
    required this.service,
    required this.route,
  }) : super(key: key);

  @override
  _SigninMethodsState createState() => _SigninMethodsState();
}

class _SigninMethodsState extends State<SigninMethodsView> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormFieldState> _email2Key = GlobalKey<FormFieldState>();
  final TextEditingController _email2Controller = TextEditingController();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormFieldState> _password2Key = GlobalKey<FormFieldState>();
  final TextEditingController _password2Controller = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _email2Controller.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlexRow(
          visible: !widget.service.reAuthed,
          children: const [
            Text('メールアドレスとパスワードの変更には、現在のメールアドレスか、'
                'または、現在のパスワードの確認が必要です。'),
          ],
        ),
        FlexRow(
          alignment: WrapAlignment.end,
          visible: !widget.service.reAuthed,
          children: [
            const SizedBox(
              width: maxContentBodyWidth / 2,
              child: Text('現在のメールアドレスを確認するためのリンクを受け取る。'),
            ),
            SendMailButton(
              onPressed: () async {
                try {
                  Conf conf = widget.service.conf!;
                  await widget.service
                      .reauthenticateWithEmailLink(url: conf.url);
                  widget.clientModel.storeRoute(widget.route);
                  showNotificationSnackBar(
                    context: context,
                    message: '確認のためのメールを ${widget.service.user?.email} に送信しました。'
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
        Visibility(
          visible: widget.service.reAuthed,
          child: Form(
            key: _emailFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Wrap(
              children: [
                FlexRow(
                  children: [
                    SizedBox(
                      width: maxContentBodyWidth / 2,
                      child: TextFormField(
                        key: _emailKey,
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
                  ],
                ),
                FlexRow(children: [
                  SizedBox(
                    width: maxContentBodyWidth / 2,
                    child: TextFormField(
                      key: _email2Key,
                      controller: _email2Controller,
                      style: const TextStyle(fontFamily: fontFamilyMonoSpace),
                      decoration: const InputDecoration(
                        label: Text('メールアドレスの確認'),
                      ),
                      validator: (String? value) =>
                          _emailController.text == _email2Controller.text
                              ? null
                              : 'メールアドレスが一致しません。',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: fontSizeBody),
                    child: FlexRow(
                      children: [
                        SaveButton(
                          onPressed: () async {
                            String email = _emailController.text;
                            if (!_emailFormKey.currentState!.validate()) {
                              showNotificationSnackBar(
                                context: context,
                                message: '入力エラーがあります。',
                              );
                            } else {
                              try {
                                await widget.service.setMyEmail(email);
                                showNotificationSnackBar(
                                  context: context,
                                  durationMilliSec: 10 * 1000,
                                  message: '保存しました。',
                                );
                              } catch (e) {
                                showNotificationSnackBar(
                                  context: context,
                                  message: 'メールアドレスの保存の処理でエラーになりました。'
                                      'やり直しても解決しない場合は管理者にお伝えください。',
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ], alignment: WrapAlignment.end),
              ],
            ),
          ),
        ),
        Form(
          key: _passwordFormKey,
          autovalidateMode: AutovalidateMode.always,
          child: Wrap(
            children: [
              FlexRow(
                visible: widget.service.reAuthed,
                children: [
                  SizedBox(
                    width: maxContentBodyWidth / 2,
                    child: TextFormField(
                      key: _passwordKey,
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      style: const TextStyle(fontFamily: fontFamilyMonoSpace),
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
                      validator: (String? value) => validateRequired(value)
                          ? (value!.length >= 8
                              ? (validatePasswordChar(value)
                                  ? null
                                  : '数字・大文字・小文字・記号のうち3種類以上を使用してください。')
                              : '8桁以上としてください。')
                          : '必須項目です。',
                    ),
                  ),
                ],
              ),
              FlexRow(
                alignment: WrapAlignment.end,
                children: [
                  SizedBox(
                    width: maxContentBodyWidth / 2,
                    child: TextFormField(
                      key: _password2Key,
                      controller: _password2Controller,
                      obscureText: !_passwordVisible,
                      style: const TextStyle(fontFamily: fontFamilyMonoSpace),
                      decoration: InputDecoration(
                        label: Text(
                          widget.service.reAuthed ? 'パスワードの確認' : '現在のパスワード',
                        ),
                        suffixIcon: VisibilityIconButton(
                          visible: _passwordVisible,
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (String? value) => widget.service.reAuthed
                          ? (_passwordController.text ==
                                  _password2Controller.text
                              ? null
                              : 'パスワードが一致しません。')
                          : (validateRequired(value) ? null : '必須項目です。'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: fontSizeBody),
                    child: FlexRow(
                      children: [
                        widget.service.reAuthed
                            ? SaveButton(
                                onPressed: () async {
                                  String password = _passwordController.text;
                                  if (!_passwordFormKey.currentState!
                                      .validate()) {
                                    showNotificationSnackBar(
                                      context: context,
                                      message: '入力エラーがあります。',
                                    );
                                  } else {
                                    try {
                                      await widget.service
                                          .setMyPassword(password);
                                      showNotificationSnackBar(
                                        context: context,
                                        durationMilliSec: 10 * 1000,
                                        message: '保存しました。',
                                      );
                                      _passwordController.text = '';
                                      _password2Controller.text = '';
                                    } catch (e) {
                                      showNotificationSnackBar(
                                        context: context,
                                        message: 'パスワードの保存の処理でエラーになりました。'
                                            'やり直しても解決しない場合は管理者にお伝えください。',
                                      );
                                    }
                                  }
                                },
                              )
                            : SendButton(
                                onPressed: () async {
                                  try {
                                    await widget.service
                                        .reauthenticateWithPassword(
                                            _password2Controller.text);
                                    setState(() {
                                      _password2Controller.text = '';
                                    });
                                  } catch (e) {
                                    showNotificationSnackBar(
                                      context: context,
                                      message: 'パスワードの確認でエラーになりました。'
                                          'やり直しても解決しない場合は管理者にお伝えください。',
                                    );
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
