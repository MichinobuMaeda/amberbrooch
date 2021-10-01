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

enum View { home, settings, policy }

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

                    Map<View, Widget> body = {
                      View.home: LoadingView(
                        firebaseModel: firebaseModel,
                        confModel: confModel,
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
                      View.settings: ScrollView(
                        child: PreferencesView(
                          themeModeModel: themeModeModel,
                          confModel: confModel,
                          authModel: authModel,
                          meModel: meModel,
                        ),
                      ),
                      View.policy: ScrollView(
                        child: PolicyView(
                          confModel: confModel,
                          me: meModel.me,
                        ),
                      ),
                    };

                    Color? colorActive(bool condition) =>
                        condition ? colorActiveView : null;

                    return Scaffold(
                      body: body[_view],
                      bottomNavigationBar: BottomAppBar(
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: fontSizeBody,
                          runSpacing: fontSizeBody / 2,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.home,
                                color: colorActive(_view == View.home),
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
                                color: colorActive(_view == View.settings),
                              ),
                              onPressed: () {
                                setState(() {
                                  _view = View.settings;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.policy,
                                color: colorActive(_view == View.policy),
                              ),
                              onPressed: () {
                                setState(() {
                                  _view = View.policy;
                                });
                              },
                            ),
                            Visibility(
                              visible: confModel.outdated,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: fontSizeBody / 8,
                                ),
                                child: DangerButton(
                                  iconData: Icons.system_update,
                                  label: 'アプリを更新してください',
                                  onPressed: () {
                                    realoadApp();
                                  },
                                ),
                              ),
                            ),
                            const Visibility(
                              visible: useEmulator,
                              child: Text(
                                'エミュレータを使用しています。'
                                '実世界のアカウントとデータを入力しないで下さい。'
                                'この行は Production 環境では表示されません。',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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
