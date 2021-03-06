part of amberbrooch;

final List<ThemeMode> themeModes = [
  ThemeMode.light,
  ThemeMode.dark,
  ThemeMode.system,
];

class TopView extends StatefulWidget {
  const TopView({Key? key}) : super(key: key);

  @override
  _TopViewState createState() => _TopViewState();
}

class _TopViewState extends State<TopView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            PageTitle(
              iconData: Icons.home,
              title: appTitle,
            ),
          ],
        );
      },
    );
  }
}
