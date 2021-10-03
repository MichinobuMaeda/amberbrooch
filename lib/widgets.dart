part of amberbrooch;

abstract class _IconLabelButton extends Widget {
  final IconData iconData;
  final String label;
  final bool disabled;
  final Function() onPressed;
  final Color? primary;

  const _IconLabelButton({
    Key? key,
    required this.iconData,
    required this.label,
    this.disabled = false,
    required this.onPressed,
    this.primary,
  }) : super(key: key);

  @override
  Element createElement() {
    return ElevatedButton.icon(
      icon: Icon(iconData),
      label: Text(label),
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(buttonWidth, buttonHeight),
        primary: primary,
      ),
    ).createElement();
  }
}

class PrimaryButton extends _IconLabelButton {
  const PrimaryButton({
    Key? key,
    required IconData iconData,
    required String label,
    bool disabled = false,
    required Function() onPressed,
  }) : super(
          key: key,
          iconData: iconData,
          label: label,
          disabled: disabled,
          onPressed: onPressed,
        );
}

class SecondaryButton extends _IconLabelButton {
  const SecondaryButton({
    Key? key,
    required IconData iconData,
    required String label,
    bool disabled = false,
    required Function() onPressed,
  }) : super(
            key: key,
            iconData: iconData,
            label: label,
            disabled: disabled,
            onPressed: onPressed,
            primary: colorSecondary);
}

class DangerButton extends _IconLabelButton {
  const DangerButton({
    Key? key,
    required IconData iconData,
    required String label,
    bool disabled = false,
    required Function() onPressed,
  }) : super(
            key: key,
            iconData: iconData,
            label: label,
            disabled: disabled,
            onPressed: onPressed,
            primary: colorDanger);
}

class SendButton extends PrimaryButton {
  const SendButton({
    Key? key,
    String label = '送信',
    bool disabled = false,
    required Function() onPressed,
  }) : super(
          key: key,
          iconData: Icons.send,
          label: label,
          disabled: disabled,
          onPressed: onPressed,
        );
}

class SendMailButton extends PrimaryButton {
  const SendMailButton({
    Key? key,
    String label = '送信',
    bool disabled = false,
    required Function() onPressed,
  }) : super(
          key: key,
          iconData: Icons.mail,
          label: label,
          disabled: disabled,
          onPressed: onPressed,
        );
}

class EditButton extends PrimaryButton {
  const EditButton({
    Key? key,
    String label = '編集',
    bool disabled = false,
    required Function() onPressed,
  }) : super(
          key: key,
          iconData: Icons.edit,
          label: label,
          disabled: disabled,
          onPressed: onPressed,
        );
}

class SaveButton extends PrimaryButton {
  const SaveButton({
    Key? key,
    String label = '保存',
    bool disabled = false,
    required Function() onPressed,
  }) : super(
          key: key,
          iconData: Icons.save_alt,
          label: label,
          disabled: disabled,
          onPressed: onPressed,
        );
}

class CancelButton extends SecondaryButton {
  const CancelButton({
    Key? key,
    String label = '中止',
    bool disabled = false,
    required Function() onPressed,
  }) : super(
          key: key,
          iconData: Icons.cancel,
          label: label,
          disabled: disabled,
          onPressed: onPressed,
        );
}

class VisibilityIconButton extends Widget {
  final bool visible;
  final Function() onPressed;

  const VisibilityIconButton({
    Key? key,
    required this.visible,
    required this.onPressed,
  }) : super(key: key);

  @override
  Element createElement() {
    return IconButton(
      icon: Icon(
        visible ? Icons.visibility : Icons.visibility_off,
        color: visible ? null : Colors.grey,
      ),
      onPressed: onPressed,
    ).createElement();
  }
}

class RadioList<T> extends Widget {
  final Map<T, String> options;
  final T groupValue;
  final Function(T?) onChanged;

  const RadioList({
    Key? key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Element createElement() {
    return Wrap(
      children: options.keys
          .map((key) => ListTile(
                title: Text(options[key] ?? ''),
                leading: Radio<T>(
                  value: key,
                  groupValue: groupValue,
                  onChanged: onChanged,
                ),
              ))
          .toList(),
    ).createElement();
  }
}

class DataCell extends Widget {
  final double height;
  final double width;
  final Widget child;
  final Color? color;

  const DataCell({
    Key? key,
    required this.height,
    required this.width,
    required this.child,
    this.color,
  }) : super(key: key);

  @override
  Element createElement() {
    return Container(
      color: color,
      height: height,
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.blueGrey, width: 1.0),
          bottom: BorderSide(color: Colors.blueGrey, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: fontSizeBody / 4,
          horizontal: fontSizeBody / 4,
        ),
        child: child,
      ),
    ).createElement();
  }
}

class DataSheet extends Widget {
  final double height;
  final double width;
  final double fixedHeight;
  final double fixedWidth;
  final Widget origin;
  final Widget colTitles;
  final Widget rowTitles;
  final Widget data;
  final ScrollController _titleScrollController = ScrollController();
  final ScrollController _dataScrollController = ScrollController();

  DataSheet({
    Key? key,
    required this.height,
    required this.width,
    required this.fixedHeight,
    required this.fixedWidth,
    required this.origin,
    required this.colTitles,
    required this.rowTitles,
    required this.data,
  }) : super(key: key);

  @override
  Element createElement() {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.topLeft,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.blueGrey, width: 1.0),
          left: BorderSide(color: Colors.blueGrey, width: 1.0),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              origin,
              SizedBox(
                width: width - fixedWidth - 1.0,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    _dataScrollController.jumpTo(_titleScrollController.offset);
                    return false;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _titleScrollController,
                    child: colTitles,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height - fixedHeight - 1.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                children: [
                  SizedBox(
                    width: fontSizeBody * 4,
                    child: rowTitles,
                  ),
                  SizedBox(
                    width: width - fixedWidth - 1.0,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        _titleScrollController
                            .jumpTo(_dataScrollController.offset);
                        return false;
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _dataScrollController,
                        child: data,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).createElement();
  }
}

DataCell origin = const DataCell(
  height: fontSizeBody * 4,
  width: fontSizeBody * 4,
  child: Text(''),
);

Row colTitles = Row(
  children: dataCols
      .map<Widget>(
        (value) => value == 'D'
            ? Column(
                children: [
                  DataCell(
                    height: fontSizeBody * 2,
                    width: fontSizeBody * 7,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    children: const [
                      DataCell(
                        height: fontSizeBody * 2,
                        width: fontSizeBody * 3.5,
                        child: Text(
                          'x',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataCell(
                        height: fontSizeBody * 2,
                        width: fontSizeBody * 3.5,
                        child: Text(
                          'y',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              )
            : DataCell(
                height: fontSizeBody * 4,
                width: fontSizeBody * 4,
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                ),
              ),
      )
      .toList(),
);

Column rowTitles = Column(
  children: dataRows
      .map<Widget>(
        (value) => DataCell(
          height: fontSizeBody * (value == '5' ? 4 : 2),
          width: fontSizeBody * 4,
          child: Text(
            value,
            textAlign: TextAlign.center,
          ),
        ),
      )
      .toList(),
);

Column data = Column(
  children: dataRows
      .map<Widget>(
        (value1) => Row(
          children: dataCols
              .map<Widget>(
                (value2) => value2 == 'D'
                    ? Row(
                        children: [
                          DataCell(
                            height: fontSizeBody * (value1 == '5' ? 4 : 2),
                            width: fontSizeBody * 3.5,
                            child: Text(
                              value2 + value1 + 'x',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DataCell(
                            height: fontSizeBody * (value1 == '5' ? 4 : 2),
                            width: fontSizeBody * 3.5,
                            child: Text(
                              value2 + value1 + 'y',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    : (value1 == '5' && value2 == 'B')
                        ? const DataCell(
                            height: fontSizeBody * 4,
                            width: fontSizeBody * 4,
                            child: Icon(Icons.comment, size: fontSizeBody * 2),
                          )
                        : DataCell(
                            height: fontSizeBody * (value1 == '5' ? 4 : 2),
                            width: fontSizeBody * 4,
                            child: Text(
                              value2 + value1,
                              textAlign: TextAlign.center,
                            ),
                          ),
              )
              .toList(),
        ),
      )
      .toList(),
);

List<String> dataCols = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
];
List<String> dataRows = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31',
  '32',
  '33',
  '34',
  '35',
  '36',
  '37',
  '38',
  '39',
  '40',
  '41',
  '42',
  '43',
  '44',
  '45',
  '46',
  '47',
  '48',
  '49',
  '50',
];

void showConfirmationDialog({
  required BuildContext context,
  String title = '操作の確認',
  required String message,
  String labelCancel = '中止する',
  String labelOK = '実行する',
  required Function onPressed,
}) =>
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.caption,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(labelCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'OK');
              await onPressed();
            },
            child: Text(labelOK),
          ),
        ],
      ),
    );

void showNotificationSnackBar({
  required BuildContext context,
  required String message,
  int durationMilliSec = 4000,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: '閉じる',
        textColor: Theme.of(context).primaryColorLight,
        onPressed: () {},
      ),
      content: Text(
        message,
        style: const TextStyle(fontFamily: fontFamilySansSerif),
      ),
      duration: Duration(milliseconds: durationMilliSec),
      padding: const EdgeInsets.symmetric(
        horizontal: fontSizeBody,
        vertical: fontSizeBody,
      ),
    ),
  );
}

class FlexRow extends Widget {
  final double spacing;
  final double runSpacing;
  final List<Widget> children;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final bool? visible;

  const FlexRow({
    Key? key,
    required this.children,
    this.spacing = fontSizeBody / 2,
    this.runSpacing = fontSizeBody / 2,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.visible,
  }) : super(key: key);

  @override
  Element createElement() {
    Widget row = Padding(
      padding: const EdgeInsets.only(bottom: fontSizeBody * 1.5),
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        alignment: alignment,
        runAlignment: runAlignment,
        children: children,
      ),
    );
    return (visible == null
            ? row
            : Visibility(
                visible: visible!,
                child: row,
              ))
        .createElement();
  }
}

class PageTitle extends Widget {
  final String title;
  final IconData iconData;

  const PageTitle({
    Key? key,
    required this.title,
    required this.iconData,
  }) : super(key: key);

  @override
  Element createElement() {
    return FlexRow(
      children: [
        Icon(iconData, size: fontSizeH2 * 1.4),
        Text(title, style: const TextStyle(fontSize: fontSizeH2)),
      ],
    ).createElement();
  }
}

class SectionTitle extends Widget {
  final String title;
  final IconData iconData;

  const SectionTitle({
    Key? key,
    required this.title,
    required this.iconData,
  }) : super(key: key);

  @override
  Element createElement() {
    return FlexRow(
      children: [
        Icon(iconData, size: fontSizeH3 * 1.4),
        Text(title, style: const TextStyle(fontSize: fontSizeH3)),
      ],
    ).createElement();
  }
}
