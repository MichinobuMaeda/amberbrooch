part of amberbrooch;

@visibleForTesting
class ThemeModeView extends StatefulWidget {
  final ServiceModel service;
  final ClientModel clientModel;

  const ThemeModeView({
    Key? key,
    required this.clientModel,
    required this.service,
  }) : super(key: key);

  @override
  _ThemeModeState createState() => _ThemeModeState();
}

class _ThemeModeState extends State<ThemeModeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToggleButtons(
          children: const [
            Icon(Icons.light_mode),
            Icon(Icons.dark_mode),
            Text('自動'),
          ],
          onPressed: (int index) {
            setState(() {
              widget.clientModel.themeMode = themeModes[index];
              widget.service.setMyThemeMode(widget.clientModel.themeMode);
            });
          },
          isSelected: [
            widget.clientModel.themeMode == themeModes[0],
            widget.clientModel.themeMode == themeModes[1],
            widget.clientModel.themeMode == themeModes[2],
          ],
        )
      ],
    );
  }
}
