part of amberbrooch;

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
          .map(
            (key) => RadioListTile(
              title: Text(options[key] ?? ''),
              value: key,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
          )
          .toList(),
    ).createElement();
  }
}
