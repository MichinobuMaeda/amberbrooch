part of amberbrooch;

class LoadingScreen extends BaseScreen {
  const LoadingScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends BaseState {
  @override
  void initState() {
    ClientModel clientModel = Provider.of<ClientModel>(context, listen: false);
    clientModel.setPackageInfo();
    Provider.of<FirebaseModel>(context, listen: false).init(
      deepLink: clientModel.deepLink,
    );
    super.initState();
  }

  @override
  Widget buildBody(BuildContext context, BoxConstraints constraints) {
    return Consumer<FirebaseModel>(
      builder: (context, firebase, child) {
        if (!firebase.initialized) {
          if (!firebase.error) {
            return LoadingStatus(
              message: '接続の準備をしています。',
              appOutdated: appOutdated,
              realoadApp: realoadApp,
            );
          } else {
            return LoadingStatus(
              message: '接続の設定のエラーです。',
              color: Theme.of(context).errorColor,
              appOutdated: appOutdated,
              subsequents: const <Widget>[
                Text('管理者に連絡してください。'),
              ],
              realoadApp: realoadApp,
            );
          }
        }

        AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
        ConfModel confModel = Provider.of<ConfModel>(context, listen: false);
        VersionModel versionModel =
            Provider.of<VersionModel>(context, listen: false);
        authModel.listen();
        confModel.listen();
        versionModel.listen();

        if (!versionModel.initialized) {
          return LoadingStatus(
            message: 'システムの情報を取得しています。',
            appOutdated: appOutdated,
            realoadApp: realoadApp,
          );
        }

        return LoadingStatus(
          message: 'システムの情報が取得できませんでした。',
          color: Theme.of(context).errorColor,
          appOutdated: appOutdated,
          subsequents: const <Widget>[
            Text('管理者に連絡してください。'),
          ],
          realoadApp: realoadApp,
        );
      },
    );
  }
}
