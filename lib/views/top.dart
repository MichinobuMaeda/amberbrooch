part of amberbrooch;

class TopView extends StatefulWidget {
  const TopView({Key? key}) : super(key: key);

  @override
  TopState createState() => TopState();
}

@visibleForTesting
class TopState extends State<TopView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        PageTitle(
          iconData: Icons.home,
          title: appTitle,
        ),
      ],
    );
  }
}
