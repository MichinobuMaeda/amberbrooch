import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'conf.dart';
import 'models.dart';
import 'widgets.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => FirebaseModel()),
      ChangeNotifierProvider(create: (context) => ConfModel()),
      ChangeNotifierProvider(create: (context) => AuthModel(auth)),
      ChangeNotifierProvider(create: (context) => ThemeModeModel()),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeModel>(
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: appTitle,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: themeMode.mode,
          home: const MyHomePage(title: appTitle),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;
  bool _sendVerificationMail = false;

  @override
  void initState() {
    Provider.of<FirebaseModel>(context, listen: false).init();
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeModeModel themeModeModel = Provider.of<ThemeModeModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: const Image(image: AssetImage('images/logo.png')),
        title: Text(widget.title),
        actions: [
          DropdownButton<ThemeMode>(
            value: themeModeModel.mode,
            onChanged: (ThemeMode? value) {
              themeModeModel.mode = value ?? defaultThemeMode;
            },
            dropdownColor: Theme.of(context).primaryColorDark,
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem<ThemeMode>(
                value: ThemeMode.light,
                child: Text('ライト'),
              ),
              DropdownMenuItem<ThemeMode>(
                value: ThemeMode.dark,
                child: Text('ダーク'),
              ),
              DropdownMenuItem<ThemeMode>(
                value: ThemeMode.system,
                child: Text('自動'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Consumer<FirebaseModel>(
          builder: (context, firebase, child) {
            if (!firebase.initialized) {
              if (!firebase.error) {
                return const LoadingStatus(
                  message: '接続の準備をしています。',
                );
              } else {
                return LoadingStatus(
                  message: '接続の設定のエラーです。',
                  color: Theme.of(context).errorColor,
                  subsequents: const <Widget>[
                    Text('管理者に連絡してください。'),
                  ],
                );
              }
            }

            Provider.of<AuthModel>(context, listen: false).listen();
            Provider.of<ConfModel>(context, listen: false).listen();

            return Consumer<ConfModel>(
              builder: (context, confModel, child) {
                Conf? conf = confModel.getConf();

                if (!confModel.initialized) {
                  return const LoadingStatus(
                    message: 'サービスの設定を取得しています。',
                  );
                } else if (conf == null) {
                  return LoadingStatus(
                    message: 'サービスの設定が取得できませんでした。',
                    color: Theme.of(context).errorColor,
                    subsequents: const <Widget>[
                      Text('管理者に連絡してください。'),
                    ],
                  );
                } else {
                  return Consumer<AuthModel>(
                    builder: (context, authModel, child) {
                      AuthUser? authUser = authModel.getUser();

                      if (authUser == null) {
                        return LoadingStatus(
                          message: 'ログインしてください。',
                          color: Theme.of(context).errorColor,
                          subsequents: useEmulator
                              ? [
                                  TextButton(
                                    child: const Text('Test'),
                                    onPressed: () =>
                                        auth.signInWithEmailAndPassword(
                                      email: testEmail,
                                      password: testPassword,
                                    ),
                                  ),
                                ]
                              : [],
                        );
                      } else if (authUser.email != null &&
                          !(authUser.emailVerified ?? false)) {
                        return LoadingStatus(
                          message: 'メールアドレスの確認が必要です。',
                          color: Theme.of(context).errorColor,
                          subsequents: <Widget>[
                            Text(
                              '確認のためのメールを ${authUser.email} に' +
                                  (_sendVerificationMail
                                      ? '送信しました。受信したメールの確認のためのリンクをクリックしてください。'
                                      : '送信します。「送信」ボタンを押してください。'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                auth.currentUser!.sendEmailVerification();
                                setState(() {
                                  _sendVerificationMail = true;
                                });
                                _timer = Timer.periodic(
                                  const Duration(seconds: 1),
                                  (timer) async {
                                    await authModel.reload();
                                    AuthUser? authUser = authModel.getUser();
                                    debugPrint('${authUser?.emailVerified}');
                                    if (authUser?.emailVerified == true) {
                                      _timer?.cancel();
                                      _timer = null;
                                    }
                                  },
                                );
                              },
                              icon: const Icon(Icons.send),
                              label: const Text('送信'),
                            )
                          ],
                        );
                      } else {
                        return LoadingStatus(
                          message: 'ログインしました。',
                          subsequents: <Widget>[Text(authUser.id)] +
                              (useEmulator
                                  ? [
                                      TextButton(
                                        child: const Text('Test'),
                                        onPressed: () => auth.signOut(),
                                      ),
                                    ]
                                  : []),
                        );
                      }
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
