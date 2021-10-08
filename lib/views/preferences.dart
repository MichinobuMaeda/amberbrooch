part of amberbrooch;

@visibleForTesting
class PreferencesView extends StatefulWidget {
  final ServiceModel service;
  final ClientModel clientModel;
  final String? routeId;

  const PreferencesView({
    Key? key,
    required this.clientModel,
    required this.service,
    this.routeId,
  }) : super(key: key);

  @override
  _PreferencesState createState() => _PreferencesState();
}

enum PreferencesPanels {
  themeMode,
  displayName,
  signinMethods,
  accounts,
}

class PreferencesPanel {
  final PreferencesPanels id;
  final String title;
  final Widget child;

  PreferencesPanel({
    required this.id,
    required this.title,
    required this.child,
  });
}

class _PreferencesState extends State<PreferencesView> {
  late String _routeId;

  @override
  void initState() {
    super.initState();
    _routeId = widget.routeId ?? describeEnum(PreferencesPanels.themeMode);
  }

  @override
  Widget build(BuildContext context) {
    Account? me = widget.service.me;

    String panelKey(PreferencesPanels id) =>
        '${AppRoute.preferences(id: describeEnum(id)).name}:'
        '${describeEnum(id)}:panel';

    List<PreferencesPanel> panels = [
      PreferencesPanel(
        id: PreferencesPanels.themeMode,
        title: '表示モード',
        child: ThemeModeView(
          key: ValueKey(panelKey(PreferencesPanels.themeMode)),
          routeId: describeEnum(PreferencesPanels.themeMode),
          clientModel: widget.clientModel,
          service: widget.service,
        ),
      ),
      if (me != null)
        PreferencesPanel(
          id: PreferencesPanels.displayName,
          title: '表示名',
          child: DisplayNameView(
            key: ValueKey(panelKey(PreferencesPanels.displayName)),
            routeId: describeEnum(PreferencesPanels.displayName),
            clientModel: widget.clientModel,
            service: widget.service,
          ),
        ),
      if (me != null)
        PreferencesPanel(
          id: PreferencesPanels.signinMethods,
          title: 'ログイン方法',
          child: SigninMethodsView(
            key: ValueKey(panelKey(PreferencesPanels.signinMethods)),
            routeId: describeEnum(PreferencesPanels.signinMethods),
            clientModel: widget.clientModel,
            service: widget.service,
          ),
        ),
      if (me?.admin == true)
        PreferencesPanel(
          id: PreferencesPanels.accounts,
          title: 'アカウント管理',
          child: AccountsView(
            key: ValueKey(panelKey(PreferencesPanels.accounts)),
            routeId: describeEnum(PreferencesPanels.accounts),
            clientModel: widget.clientModel,
            service: widget.service,
          ),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageTitle(
          iconData: Icons.settings,
          title: 'アプリの情報と設定',
        ),
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _routeId = isExpanded ? '' : describeEnum(panels[index].id);
            });
          },
          children: panels
              .map<ExpansionPanel>((panel) => ExpansionPanel(
                    isExpanded: _routeId == describeEnum(panel.id),
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(title: Text(panel.title));
                    },
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: fontSizeBody / 2,
                        horizontal: fontSizeBody / 2,
                      ),
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: double.infinity),
                        child: panel.child,
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
                    widget.clientModel.goRoute(context, AppRoute.policy());
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
    );
  }
}
