import 'package:flutter/material.dart';
import '../conf.dart';
import '../router.dart';
import '../widgets.dart';

abstract class BaseScreen extends StatefulWidget {
  final ValueChanged<AppRoutePath> pushRoute;

  const BaseScreen({
    Key? key,
    required this.pushRoute,
  }) : super(key: key);

  @override
  BaseState createState();
}

abstract class BaseState extends State<BaseScreen> {
  Widget buildBody(BuildContext context);
  late PrimaryButton returnButton;

  @override
  Widget build(BuildContext context) {
    returnButton = PrimaryButton(
      iconData: Icons.navigate_before,
      label: '戻る',
      onPressed: () {
        widget.pushRoute(AppRoutePath.top());
      },
    );

    return Scaffold(
      appBar: Header(
        context: context,
        pushRoute: widget.pushRoute,
        appTitle: appTitle,
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 44.0, // Height of AppBar
            ),
            child: buildBody(context),
          ),
        );
      }),
    );
  }
}
