part of amberbrooch;

class ScrollView extends StatelessWidget {
  final Widget child;

  const ScrollView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: fontSizeBody / 2,
            vertical: fontSizeBody / 2,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: maxContentBodyWidth,
                minWidth: maxContentBodyWidth,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
