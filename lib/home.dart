part of amberbrooch;

class MainMenuItem {
  Function action;
  MainMenuItem(this.action);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

enum View { home, settings }

class HomeState extends State<HomePage> {
  View _view = View.home;

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseModel>(
      builder: (context, firebaseModel, child) {
        return Consumer<ConfModel>(
          builder: (context, confModel, child) {
            return Consumer<AuthModel>(
              builder: (context, authModel, child) {
                return Consumer<MeModel>(
                  builder: (context, meModel, child) {
                    ThemeModeModel themeModeModel =
                        Provider.of<ThemeModeModel>(context, listen: false);

                    return Scaffold(
                      body: _view == View.settings
                          ? ScrollView(
                              child: PreferencesView(
                                themeModeModel: themeModeModel,
                                confModel: confModel,
                                authModel: authModel,
                                meModel: meModel,
                              ),
                            )
                          : LoadingView(
                              firebaseModel: firebaseModel,
                              versionModel: confModel,
                              child: meModel.me == null
                                  ? ScrollView(
                                      child: SignInView(
                                        conf: confModel.conf,
                                        authModel: authModel,
                                      ),
                                    )
                                  : authModel.user?.emailVerified == false
                                      ? ScrollView(
                                          child: VerifyEmailView(
                                            authModel: authModel,
                                          ),
                                        )
                                      : const ScrollView(
                                          child: TopView(),
                                        ),
                            ),
                      bottomNavigationBar: BottomAppBar(
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: fontSizeBody,
                          runSpacing: fontSizeBody / 2,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.home,
                                color:
                                    _view == View.home ? colorActiveView : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  _view = View.home;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: _view == View.settings
                                    ? colorActiveView
                                    : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  _view = View.settings;
                                });
                              },
                            ),
                            if (confModel.outdated)
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: fontSizeBody / 8,
                                  ),
                                  child: DangerButton(
                                    iconData: Icons.system_update,
                                    label: 'アプリを更新してください',
                                    onPressed: () {
                                      realoadApp();
                                    },
                                  )),
                            if (useEmulator)
                              const Text(
                                'エミュレータを使用しています。'
                                '実世界のアカウントとデータを入力しないで下さい。'
                                'この行は Production 環境では表示されません。',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                        // ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
