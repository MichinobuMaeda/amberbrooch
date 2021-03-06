part of amberbrooch;

class PolicyScreen extends BaseScreen {
  const PolicyScreen({
    Key? key,
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
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  bool _editMode = false;
  final GlobalKey<FormState> _keyPolicy = GlobalKey<FormState>();
  final _policyController = TextEditingController();
  final _policyFocusNode = FocusNode();
  final GlobalKey<State<MarkdownBody>> _keyMarkdown =
      GlobalKey<State<MarkdownBody>>();

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
    Conf? conf = widget.service.conf;
    _policyController.text = conf?.policy ?? '';

    return scaffoldApp(
      clientModel: widget.clientModel,
      service: widget.service,
      route: widget.route,
      child: ScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageTitle(
              iconData: Icons.policy,
              title: 'プライバシー・ポリシー',
            ),
            Visibility(
              visible: widget.service.me?.admin == true && !_editMode,
              child: Row(
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
            ),
            FlexRow(
              alignment: WrapAlignment.end,
              visible: widget.service.me?.admin == true && _editMode,
              children: [
                SaveButton(
                  onPressed: () async {
                    _editMode = false;
                    await widget.service.setPolicy(_policyController.text);
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
                  style: const TextStyle(fontFamily: fontFamilyMonoSpace),
                ),
              ],
            ),
            Visibility(
              visible: widget.service.me?.admin != true || !_editMode,
              child: MarkdownBody(
                key: _keyMarkdown,
                selectable: true,
                data: conf?.policy ?? '',
                styleSheet: MarkdownStyleSheet(
                  h1: const TextStyle(fontSize: fontSizeH1),
                  h2: const TextStyle(fontSize: fontSizeH2),
                  h3: const TextStyle(fontSize: fontSizeH3),
                  h4: const TextStyle(fontSize: fontSizeH4),
                  h5: const TextStyle(fontSize: fontSizeH5),
                  h6: const TextStyle(fontSize: fontSizeH6),
                  p: const TextStyle(fontSize: fontSizeBody),
                  code: const TextStyle(fontSize: fontSizeBody),
                ),
                onTapLink: (String text, String? href, String title) {
                  if (href != null) {
                    html.window.open(href, '_blank');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
