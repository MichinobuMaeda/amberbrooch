part of amberbrooch;

class AppLayout extends Widget {
  final List<Widget> children;
  final bool loading;
  final bool centering;
  final bool appOutdated;

  const AppLayout({
    Key? key,
    required this.children,
    this.loading = false,
    this.centering = false,
    required this.appOutdated,
  }) : super(key: key);

  @override
  Element createElement() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: const TextStyle(fontSize: kToolbarHeight - 32.0),
        ),
        actions: [
          IconButton(
            icon: Image.asset('images/logo.png'),
            iconSize: kToolbarHeight - 16.0,
            onPressed: () {
              pushRoute(AppRoutePath.preferences());
            },
          )
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                children: [
                  if (loading)
                    const LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepOrangeAccent,
                      ),
                      minHeight: fontSizeBody / 2,
                    ),
                  if (appOutdated)
                    Padding(
                      padding: const EdgeInsets.only(top: fontSizeBody / 4),
                      child: Wrap(
                        runAlignment: WrapAlignment.center,
                        children: const [AppUpdateButton()],
                      ),
                    ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: maxContentBodyWidth,
                      minWidth: maxContentBodyWidth,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(fontSizeBody),
                      child: Column(
                        crossAxisAlignment: centering
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: children,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ).createElement();
  }
}

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

  const FlexRow(
    this.children, {
    Key? key,
    this.spacing = fontSizeBody / 2,
    this.runSpacing = fontSizeBody / 2,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
  }) : super(key: key);

  @override
  Element createElement() {
    return Padding(
      padding: const EdgeInsets.only(bottom: fontSizeBody * 1.5),
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        alignment: alignment,
        runAlignment: runAlignment,
        children: children,
      ),
    ).createElement();
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
    return FlexRow([
      Icon(iconData, size: fontSizeH2 * 1.4),
      Text(title, style: const TextStyle(fontSize: fontSizeH2)),
    ]).createElement();
  }
}

class AppUpdateButton extends Widget {
  const AppUpdateButton({Key? key}) : super(key: key);

  @override
  Element createElement() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.download),
      label: const Text(
        'アプリを更新してください',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(buttonWidth * 3, buttonHeight),
        primary: colorDanger,
      ),
      onPressed: () => realoadApp(),
    ).createElement();
  }
}

class ShowAboutButton extends Widget {
  final BuildContext context;
  final String appTitle;
  final PackageInfo? packageInfo;

  const ShowAboutButton({
    Key? key,
    required this.context,
    required this.appTitle,
    required this.packageInfo,
  }) : super(key: key);

  @override
  Element createElement() {
    return PrimaryButton(
      iconData: Icons.info,
      label: 'このアプリについて',
      onPressed: () {
        showAboutDialog(
          context: context,
          applicationIcon: const Image(
            image: AssetImage('images/logo.png'),
            width: fontSizeBody * 3,
            height: fontSizeBody * 3,
          ),
          applicationName: appTitle,
          applicationVersion: packageInfo == null
              ? 'unknown'
              : 'v${packageInfo!.version}+${packageInfo!.buildNumber}',
          children: [
            const Text(
              '© 2021 Michinobu Maeda.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
      },
    ).createElement();
  }
}
