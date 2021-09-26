part of amberbrooch;

class TopScreen extends BaseScreen {
  const TopScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _TopState createState() => _TopState();
}

class _TopState extends BaseState {
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
              widget.pushRoute(AppRoutePath.preferences());
            },
          ),
        ]),
      ],
    );
  }
}
