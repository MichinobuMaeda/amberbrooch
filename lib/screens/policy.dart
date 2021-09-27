part of amberbrooch;

class PolicyPage extends Page {
  const PolicyPage({LocalKey? key}) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => PolicyScreen(),
    );
  }
}

@visibleForTesting
class PolicyScreen extends BaseScreen {
  const PolicyScreen({
    Key? key,
  }) : super(key: key);

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
  void dispose() {
    _policyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<State<MarkdownBody>> _keyMarkdown =
        GlobalKey<State<MarkdownBody>>();

    return Consumer<ConfModel>(
      builder: (context, confModel, child) {
        Conf? conf = confModel.conf;
        MeModel meModel = Provider.of<MeModel>(context, listen: false);
        Account? me = meModel.me;
        _policyController.text = conf?.policy ?? '';

        return AppLayout(
          appOutdated: appOutdated(context),
          children: [
            const PageTitle(
              iconData: Icons.policy,
              title: 'プライバシー・ポリシー',
            ),
            if (me?.admin == true && !_editMode)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _editMode = true;
                      });
                    },
                  )
                ],
              ),
            if (me?.admin == true && _editMode)
              FlexRow([
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
                  style: const TextStyle(fontFamily: fontFamilyMonoSpace),
                ),
              ], alignment: WrapAlignment.end),
            if (me?.admin != true || !_editMode)
              FlexRow([
                MarkdownBody(
                  key: _keyMarkdown,
                  selectable: true,
                  data: conf?.policy ?? '',
                  styleSheet: markdownStyleSheet,
                  onTapLink: (String text, String? href, String title) {
                    if (href != null) {
                      html.window.open(href, '_blank');
                    }
                  },
                ),
              ]),
          ],
        );
      },
    );
  }
}
