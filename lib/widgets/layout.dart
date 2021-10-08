part of amberbrooch;

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
