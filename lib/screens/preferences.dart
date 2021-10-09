part of amberbrooch;

enum PreferencesPanel {
  themeMode,
  displayName,
  signinMethods,
  accounts,
}

class PreferencesPanelItem {
  final PreferencesPanel panel;
  final String title;
  final Widget child;

  PreferencesPanelItem({
    required this.panel,
    required this.title,
    required this.child,
  });
}

class PreferencesScreen extends BaseScreen {
  final String? panel;

  const PreferencesScreen({
    Key? key,
    this.panel,
    required ClientModel clientModel,
    required ServiceModel service,
    required AppRoute route,
  }) : super(
          key: key,
          clientModel: clientModel,
          service: service,
          route: route,
        );

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  PreferencesPanel? _panel = PreferencesPanel.themeMode;

  @override
  void initState() {
    super.initState();
    for (PreferencesPanel p in PreferencesPanel.values) {
      if (describeEnum(p) == widget.panel) {
        _panel = p;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Account? me = widget.service.me;

    ValueKey panelKey(PreferencesPanel panel) => ValueKey(
          '${AppRoute.preferences().toString()}:${describeEnum(panel)}',
        );

    List<PreferencesPanelItem> panels = [
      PreferencesPanelItem(
        panel: PreferencesPanel.themeMode,
        title: '表示モード',
        child: ThemeModeView(
          key: panelKey(PreferencesPanel.themeMode),
          clientModel: widget.clientModel,
          service: widget.service,
        ),
      ),
      if (me != null)
        PreferencesPanelItem(
          panel: PreferencesPanel.displayName,
          title: '表示名',
          child: DisplayNameView(
            key: panelKey(PreferencesPanel.displayName),
            clientModel: widget.clientModel,
            service: widget.service,
          ),
        ),
      if (me != null)
        PreferencesPanelItem(
          panel: PreferencesPanel.signinMethods,
          title: 'ログイン方法',
          child: SigninMethodsView(
            key: panelKey(PreferencesPanel.signinMethods),
            clientModel: widget.clientModel,
            service: widget.service,
          ),
        ),
      if (me?.admin == true)
        PreferencesPanelItem(
          panel: PreferencesPanel.accounts,
          title: 'アカウント管理',
          child: AccountsView(
            key: panelKey(PreferencesPanel.accounts),
            clientModel: widget.clientModel,
            service: widget.service,
          ),
        ),
    ];

    return scaffoldApp(
      clientModel: widget.clientModel,
      service: widget.service,
      route: widget.route,
      child: ScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageTitle(
              iconData: Icons.settings,
              title: 'アプリの情報と設定',
            ),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _panel = isExpanded ? null : panels[index].panel;
                });
              },
              children: panels
                  .map<ExpansionPanel>((item) => ExpansionPanel(
                        isExpanded: _panel == item.panel,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(title: Text(item.title));
                        },
                        body: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: fontSizeBody / 2,
                            horizontal: fontSizeBody / 2,
                          ),
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(minWidth: double.infinity),
                            child: item.child,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: fontSizeBody),
            FlexRow(
              children: [
                Visibility(
                  visible: me != null,
                  child: DangerButton(
                    iconData: Icons.logout,
                    label: 'ログアウト',
                    onPressed: () => showConfirmationDialog(
                      context: context,
                      message: 'ログアウトしますか？',
                      onPressed: () async {
                        await widget.service.signOut(context: context);
                      },
                    ),
                  ),
                ),
                FlexRow(
                  children: [
                    TextButton(
                      child: const Text('プライバシー・ポリシー'),
                      onPressed: () {
                        widget.clientModel.goRoute(AppRoute.policy());
                      },
                    ),
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
                        applicationVersion: version,
                        children: [
                          const Text(copyRight),
                          const Text(licenseNotice),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
