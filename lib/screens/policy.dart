part of amberbrooch;

class PolicyPage extends Page {
  final ValueChanged<AppRoutePath> pushRoute;

  const PolicyPage({
    required this.pushRoute,
  }) : super(key: const ValueKey('PolicyPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => PolicyScreen(pushRoute: pushRoute),
    );
  }
}

class PolicyScreen extends BaseScreen {
  const PolicyScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _PolicyState createState() => _PolicyState();
}

class _PolicyState extends BaseState {
  bool _editMode = false;
  final GlobalKey<FormState> _keyPolicy = GlobalKey<FormState>();
  final _policyController = TextEditingController();
  final _policyFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _policyFocusNode.addListener(() {
      if (_policyFocusNode.hasFocus) {
        _policyController.selection =
            const TextSelection(baseOffset: 0, extentOffset: 0);
      }
    });
  }

  @override
  Widget buildBody(BuildContext context, BoxConstraints constraints) {
    final GlobalKey<State<MarkdownBody>> _keyMarkdown =
        GlobalKey<State<MarkdownBody>>();

    return Consumer<ConfModel>(
      builder: (context, confModel, child) {
        return Consumer<MeModel>(
          builder: (context, mefModel, child) {
            Conf? conf = confModel.conf;
            Account? me = mefModel.me;
            _policyController.text = conf?.policy ?? '';

            return ContentBody([
              PageTitle(
                iconData: Icons.policy,
                title: 'プライバシー・ポリシー',
                appOutdated: appOutdated,
                realoadApp: realoadApp,
              ),
              if (me?.admin == true && !_editMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _editMode = true;
                        });
                      },
                      icon: const Icon(Icons.edit),
                    )
                  ],
                ),
              if (me?.admin == true && _editMode)
                FlexRow(
                  [
                    SaveButton(
                      onPressed: () {
                        _editMode = false;
                        db.collection('service').doc('conf').update({
                          'policy': _policyController.text,
                          'updatedAt': DateTime.now(),
                        });
                      },
                    ),
                    CancelButton(
                      onPressed: () {
                        setState(() {
                          _editMode = false;
                        });
                      },
                    ),
                    TextField(
                      key: _keyPolicy,
                      controller: _policyController,
                      focusNode: _policyFocusNode,
                      maxLines: 10,
                      autofocus: true,
                    ),
                  ],
                  alignment: WrapAlignment.end,
                ),
              if (me?.admin != true || !_editMode)
                FlexRow([
                  MarkdownBody(
                    key: _keyMarkdown,
                    selectable: true,
                    data: conf?.policy ?? '',
                    styleSheet: MarkdownStyleSheet(
                      h1: const TextStyle(fontSize: 40.0),
                      h2: const TextStyle(fontSize: 28.0),
                      h3: const TextStyle(fontSize: 24.0),
                      h4: const TextStyle(fontSize: 22.0),
                      h5: const TextStyle(fontSize: 20.0),
                      h6: const TextStyle(fontSize: 18.0),
                      p: const TextStyle(fontSize: 16.0),
                      code: const TextStyle(fontSize: 16.0),
                    ),
                    onTapLink: (String text, String? href, String title) {
                      if (href != null) {
                        html.window.open(href, '_blank');
                      }
                    },
                  ),
                ]),
            ]);
          },
        );
      },
    );
  }
}
