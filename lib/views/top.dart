part of amberbrooch;

final List<ThemeMode> themeModes = [
  ThemeMode.light,
  ThemeMode.dark,
  ThemeMode.system,
];

class TopView extends StatefulWidget {
  const TopView({Key? key}) : super(key: key);

  @override
  TopState createState() => TopState();
}

@visibleForTesting
class TopState extends State<TopView> {
  @override
  Widget build(BuildContext context) {
    ClientModel clientModel = Provider.of<ClientModel>(context, listen: false);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: fontSizeBody,
                horizontal: fontSizeBody,
              ),
              child: ToggleButtons(
                children: const [
                  Icon(Icons.light_mode),
                  Icon(Icons.dark_mode),
                ],
                onPressed: (int index) {
                  setState(() {
                    clientModel.themeMode = themeModes[index];
                    // meModel.setThemeMode(clientModel.themeMode);
                  });
                },
                isSelected: [
                  clientModel.themeMode == themeModes[0],
                  clientModel.themeMode == themeModes[1],
                ],
              ),
            ),
            // const PageTitle(
            //   iconData: Icons.home,
            //   title: appTitle,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: fontSizeBody,
                horizontal: fontSizeBody,
              ),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight - 128.0,
                child: StickyHeadersTable(
                  columnsLength: dataCols.length,
                  rowsLength: dataRows.length,
                  columnsTitleBuilder: (i) => Text(dataCols[i]),
                  rowsTitleBuilder: (i) => Text(dataRows[i]),
                  contentCellBuilder: (i, j) =>
                      Text('${dataCols[i]}${dataRows[j]}'),
                  legendCell: const Text(''),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
