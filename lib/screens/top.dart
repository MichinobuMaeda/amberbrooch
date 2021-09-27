part of amberbrooch;

class TopScreen extends BaseScreen {
  const TopScreen({Key? key}) : super(key: key);

  @override
  TopState createState() => TopState();
}

@visibleForTesting
class TopState extends BaseState {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      appOutdated: appOutdated(context),
      children: [
        PageTitle(
          iconData: Icons.home,
          title: appTitle,
        ),
        FlexRow([
          PrimaryButton(
            iconData: Icons.settings,
            label: 'アプリの情報と設定',
            onPressed: () {
              pushRoute(AppRoutePath.preferences());
            },
          ),
        ]),
      ],
    );
  }
}
