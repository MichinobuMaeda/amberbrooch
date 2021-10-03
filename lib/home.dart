part of amberbrooch;

class MainMenuItem {
  Function action;
  MainMenuItem(this.action);
}

class HomePage extends StatefulWidget {
  final ClientModel clientModel;

  const HomePage({
    Key? key,
    required this.clientModel,
  }) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
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
                    ClientModel clientModel =
                        Provider.of<ClientModel>(context, listen: false);

                    Map<View, Widget> body = {
                      View.home: LoadingView(
                        firebaseModel: firebaseModel,
                        confModel: confModel,
                        child: meModel.me == null
                            ? ScrollView(
                                child: SignInView(
                                  conf: confModel.conf,
                                  authModel: authModel,
                                  firebaseModel: firebaseModel,
                                ),
                              )
                            : authModel.user?.emailVerified == false
                                ? ScrollView(
                                    child: VerifyEmailView(
                                      authModel: authModel,
                                    ),
                                  )
                                : const TopView(),
                      ),
                      View.preferences: ScrollView(
                        child: PreferencesView(
                          clientModel: clientModel,
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
                      body: body[widget.clientModel.view],
                      bottomNavigationBar: BottomAppBar(
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: fontSizeBody,
                          runSpacing: fontSizeBody / 2,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.home,
                                color: colorActive(
                                  widget.clientModel.view == View.home,
                                ),
                              ),
                              onPressed: () {
                                widget.clientModel.view = View.home;
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: colorActive(
                                  widget.clientModel.view == View.preferences,
                                ),
                              ),
                              onPressed: () {
                                widget.clientModel.view = View.preferences;
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.policy,
                                color: colorActive(
                                  widget.clientModel.view == View.policy,
                                ),
                              ),
                              onPressed: () {
                                widget.clientModel.view = View.policy;
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
                                    realoadApp(Navigator.of(context));
                                  },
                                ),
                              ),
                            ),
                            Visibility(
                              visible: firebaseModel.useEmulator,
                              child: const Text(
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
