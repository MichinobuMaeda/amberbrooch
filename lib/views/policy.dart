part of amberbrooch;

class PolicyView extends StatefulWidget {
  final ConfModel confModel;
  final Account? me;

  const PolicyView({
    Key? key,
    required this.confModel,
    this.me,
  }) : super(key: key);

  @override
  PolicyState createState() => PolicyState();
}

class PolicyState extends State<PolicyView> {
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
    Conf? conf = widget.confModel.conf;
    _policyController.text = conf?.policy ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageTitle(
          iconData: Icons.policy,
          title: 'プライバシー・ポリシー',
        ),
        if (widget.me?.admin == true && !_editMode)
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
        if (widget.me?.admin == true && _editMode)
          FlexRow([
            SaveButton(
              onPressed: () async {
                _editMode = false;
                await widget.confModel.setPolicy(_policyController.text);
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
        if (widget.me?.admin != true || !_editMode)
          // Expanded(
          // child:
          MarkdownBody(
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
        // ),
      ],
    );
  }
}
