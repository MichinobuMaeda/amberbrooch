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
  // final ScrollController _holizontalScrollController = ScrollController();

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
    return Column(
      children: [
        Container(
          width: width,
          height: height - fontSizeBody * 2,
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
                        _dataScrollController
                            .jumpTo(_titleScrollController.offset);
                        return true;
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
                height: height - fixedHeight - fontSizeBody * 2 - 1.0,
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
                            return true;
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
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.first_page),
              onPressed: () {
                _dataScrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.ease,
                );
              },
            ),
            const Spacer(flex: 1),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                _dataScrollController.animateTo(
                  max(
                      0,
                      _dataScrollController.position.pixels -
                          (width - fixedWidth) / 4),
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.ease,
                );
              },
            ),
            const Spacer(flex: 4),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_right),
              onPressed: () {
                _dataScrollController.animateTo(
                  min(
                      _dataScrollController.position.pixels +
                          (width - fixedWidth) / 4,
                      _dataScrollController.position.maxScrollExtent),
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.ease,
                );
              },
            ),
            const Spacer(flex: 1),
            IconButton(
              icon: const Icon(Icons.last_page),
              onPressed: () {
                _dataScrollController.animateTo(
                  _dataScrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.ease,
                );
              },
            ),
          ],
        ),
      ],
    ).createElement();
  }
}

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
