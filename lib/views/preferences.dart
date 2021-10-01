part of amberbrooch;

@visibleForTesting
class PreferencesView extends StatefulWidget {
  final MeModel meModel;
  final ConfModel confModel;
  final AuthModel authModel;
  final ThemeModeModel themeModeModel;

  const PreferencesView({
    Key? key,
    required this.themeModeModel,
    required this.confModel,
    required this.authModel,
    required this.meModel,
  }) : super(key: key);

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<PreferencesView> {
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();
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
  final List<ThemeMode> themeModes = [
    ThemeMode.light,
    ThemeMode.dark,
    ThemeMode.system,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _email2Controller.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Account? me = widget.meModel.me;
    _nameController.text = me?.name ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageTitle(
          iconData: Icons.settings,
          title: 'アプリの情報と設定',
        ),
        FlexRow(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text('表示モード'),
            ),
            ToggleButtons(
              children: const [
                Icon(Icons.light_mode),
                Icon(Icons.dark_mode),
                Text('自動'),
              ],
              onPressed: (int index) {
                setState(() {
                  widget.themeModeModel.mode = themeModes[index];
                  widget.meModel.setThemeMode(widget.themeModeModel.mode);
                });
              },
              isSelected: [
                widget.themeModeModel.mode == themeModes[0],
                widget.themeModeModel.mode == themeModes[1],
                widget.themeModeModel.mode == themeModes[2],
              ],
            ),
          ],
        ),
        Visibility(
          visible: me != null,
          child: Form(
            key: _nameFormKey,
            autovalidateMode: AutovalidateMode.always,
            child: FlexRow(
              alignment: WrapAlignment.end,
              children: [
                SizedBox(
                  width: maxContentBodyWidth / 2,
                  child: TextFormField(
                    key: _nameKey,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      label: Text('表示名'),
                    ),
                    validator: (String? value) =>
                        validateRequired(value) ? null : '必ず記入してください',
                    autofocus: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: fontSizeBody),
                  child: FlexRow(
                    children: [
                      SaveButton(
                        onPressed: () async {
                          if (!_nameFormKey.currentState!.validate()) {
                            showNotificationSnackBar(
                              context: context,
                              message: '表示名は必ず記入してください。',
                            );
                          } else if (_nameController.text == me!.name) {
                            showNotificationSnackBar(
                              context: context,
                              message: '表示名は変更されていません。',
                            );
                          } else {
                            await widget.meModel.setName(_nameController.text);
                            showNotificationSnackBar(
                              context: context,
                              message: '表示名を保存しました。',
                            );
                          }
                        },
                      ),
                      CancelButton(
                        onPressed: () {
                          _nameFormKey.currentState!.reset();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        FlexRow(
          visible: me != null && !widget.authModel.reAuthed,
          children: const [
            Text('メールアドレスとパスワードの変更には、現在のメールアドレスか、'
                'または、現在のパスワードの確認が必要です。'),
          ],
        ),
        FlexRow(
          alignment: WrapAlignment.end,
          visible: me != null && !widget.authModel.reAuthed,
          children: [
            const SizedBox(
              width: maxContentBodyWidth / 2,
              child: Text('現在のメールアドレスを確認するためのリンクを受け取る。'),
            ),
            SendMailButton(
              onPressed: () async {
                try {
                  Conf conf =
                      Provider.of<ConfModel>(context, listen: false).conf!;
                  await widget.authModel
                      .reauthenticateWithEmailLink(url: conf.url);
                  LocalStorage().pageName = 'preferences';
                  LocalStorage().pageId = '';
                  showNotificationSnackBar(
                    context: context,
                    message:
                        '確認のためのメールを ${widget.authModel.user?.email} に送信しました。'
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
          visible: me != null && widget.authModel.reAuthed,
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
                                await widget.authModel.setMyEmail(email);
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
        Visibility(
          visible: me != null,
          child: Form(
            key: _passwordFormKey,
            autovalidateMode: AutovalidateMode.always,
            child: Wrap(
              children: [
                FlexRow(
                  visible: widget.authModel.reAuthed,
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
                            widget.authModel.reAuthed ? 'パスワードの確認' : '現在のパスワード',
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
                        validator: (String? value) => widget.authModel.reAuthed
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
                          widget.authModel.reAuthed
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
                                        await widget.authModel
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
                                      await widget.authModel
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
        ),
        FlexRow(
          visible: me != null,
          children: [
            DangerButton(
              iconData: Icons.logout,
              label: 'ログアウト',
              onPressed: () => showConfirmationDialog(
                context: context,
                message: 'ログアウトしますか？',
                onPressed: () async {
                  await widget.authModel.signOut();
                },
              ),
            ),
          ],
        ),
        FlexRow(
          children: [
            TextButton(
              child: const Text('Copyright'),
              onPressed: () => showAboutDialog(
                useRootNavigator: false,
                context: context,
                applicationIcon: const Image(
                  image: AssetImage('images/logo.png'),
                  width: fontSizeBody * 3,
                  height: fontSizeBody * 3,
                ),
                applicationName: appTitle,
                applicationVersion: widget.confModel.version,
                children: [
                  const Text(copyRight),
                  const Text(licenseNotice),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
