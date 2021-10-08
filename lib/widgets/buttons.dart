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
