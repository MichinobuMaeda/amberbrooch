part of amberbrooch;

@visibleForTesting
class DisplayNameView extends StatefulWidget {
  final String routeId;
  final ServiceModel service;
  final ClientModel clientModel;

  const DisplayNameView({
    Key? key,
    required this.routeId,
    required this.clientModel,
    required this.service,
  }) : super(key: key);

  @override
  _DisplayNameState createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayNameView> {
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Account? me = widget.service.me;
    _nameController.text = widget.service.me?.name ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: _nameFormKey,
          autovalidateMode: AutovalidateMode.always,
          child: FlexRow(
            alignment: WrapAlignment.end,
            children: [
              SizedBox(
                width: maxContentBodyWidth / 2,
                child: TextFormField(
                  key: _nameKey,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    label: Text('表示名'),
                  ),
                  validator: (String? value) =>
                      validateRequired(value) ? null : '必ず記入してください',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: fontSizeBody),
                child: FlexRow(
                  children: [
                    SaveButton(
                      onPressed: () async {
                        if (!_nameFormKey.currentState!.validate()) {
                          showNotificationSnackBar(
                            context: context,
                            message: '表示名は必ず記入してください。',
                          );
                        } else if (_nameController.text == me?.name) {
                          showNotificationSnackBar(
                            context: context,
                            message: '表示名は変更されていません。',
                          );
                        } else {
                          await widget.service.setMyName(_nameController.text);
                          showNotificationSnackBar(
                            context: context,
                            message: '表示名を保存しました。',
                          );
                        }
                      },
                    ),
                    CancelButton(
                      onPressed: () {
                        _nameFormKey.currentState!.reset();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
