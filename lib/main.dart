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
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const MyHomePage(title: appTitle),
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
  @override
  void initState() {
    Provider.of<FirebaseModel>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
            } else {
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
            }
          },
        ),
      ),
    );
  }
}
