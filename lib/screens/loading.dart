part of amberbrooch;

class LoadingScreen extends BaseScreen {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  LoadingState createState() => LoadingState();
}

@visibleForTesting
class LoadingState extends BaseState {
  @override
  void initState() {
    super.initState();
    ClientModel clientModel = Provider.of<ClientModel>(context, listen: false);
    _setPackageInfo(clientModel);
    Provider.of<FirebaseModel>(context, listen: false).init(
      deepLink: clientModel.deepLink,
      authModel: Provider.of<AuthModel>(context, listen: false),
      initFirebase: initFirebase,
    );
  }

  Future<void> _setPackageInfo(ClientModel clientModel) async {
    clientModel.packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseModel>(
      builder: (context, firebase, child) {
        if (!firebase.initialized) {
          if (!firebase.error) {
            return AppLayout(
              centering: true,
              loading: true,
              appOutdated: appOutdated(context),
              children: const [
                SizedBox(height: fontSizeBody * 3),
                FlexRow([
                  Text(
                    '接続の準備をしています。',
                    style: TextStyle(
                      fontSize: fontSizeH4,
                    ),
                  ),
                ]),
              ],
            );
          }

          return AppLayout(
            appOutdated: appOutdated(context),
            children: const [
              SizedBox(height: fontSizeBody * 3),
              FlexRow([
                Text(
                  '接続の設定のエラーです。',
                  style: TextStyle(
                    color: colorDanger,
                    fontSize: fontSizeH4,
                  ),
                ),
              ]),
              FlexRow([
                Text('管理者に連絡してください。'),
              ]),
            ],
          );
        }

        AuthModel authModel = Provider.of<AuthModel>(context, listen: false);
        ConfModel confModel = Provider.of<ConfModel>(context, listen: false);
        VersionModel versionModel =
            Provider.of<VersionModel>(context, listen: false);
        authModel.listen();
        confModel.listen(db);
        versionModel.listen(db);

        if (!versionModel.initialized) {
          return AppLayout(
            centering: true,
            loading: true,
            appOutdated: appOutdated(context),
            children: const [
              SizedBox(height: fontSizeBody * 3),
              FlexRow([
                Text(
                  'システムの情報を取得しています。',
                  style: TextStyle(
                    fontSize: fontSizeH4,
                  ),
                ),
              ]),
            ],
          );
        }

        return AppLayout(
          centering: true,
          appOutdated: appOutdated(context),
          children: const [
            SizedBox(height: fontSizeBody * 3),
            FlexRow([
              Text(
                'システムの情報が取得できませんでした。',
                style: TextStyle(
                  color: colorDanger,
                  fontSize: fontSizeH4,
                ),
              ),
            ]),
            FlexRow([
              Text('管理者に連絡してください。'),
            ]),
          ],
        );
      },
    );
  }
}
