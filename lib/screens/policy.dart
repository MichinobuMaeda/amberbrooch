import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import "package:universal_html/html.dart";
import '../widgets.dart';
import '../models.dart';
import '../router.dart';
import 'base.dart';

class PolicyPage extends Page {
  final ValueChanged<AppRoutePath> pushRoute;

  const PolicyPage({
    required this.pushRoute,
  }) : super(key: const ValueKey('PolicyPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) => PolicyScreen(pushRoute: pushRoute),
    );
  }
}

class PolicyScreen extends BaseScreen {
  const PolicyScreen({
    Key? key,
    required pushRoute,
  }) : super(key: key, pushRoute: pushRoute);

  @override
  _PolicyState createState() => _PolicyState();
}

class _PolicyState extends BaseState {
  @override
  Widget buildBody(BuildContext context, BoxConstraints constraints) {
    final GlobalKey<State<MarkdownBody>> _keyMarkdown =
        GlobalKey<State<MarkdownBody>>();
    Conf? conf = Provider.of<ConfModel>(context, listen: false).conf;

    return ContentBody([
      PageTitle(
        iconData: Icons.policy,
        title: 'プライバシー・ポリシー',
        appOutdated: appOutdated,
      ),
      FlexRow([
        MarkdownBody(
          key: _keyMarkdown,
          selectable: true,
          data: conf?.policy ?? '',
          styleSheet: MarkdownStyleSheet(
            h1: const TextStyle(fontSize: 40.0),
            h2: const TextStyle(fontSize: 28.0),
            h3: const TextStyle(fontSize: 24.0),
            h4: const TextStyle(fontSize: 22.0),
            h5: const TextStyle(fontSize: 20.0),
            h6: const TextStyle(fontSize: 18.0),
            p: const TextStyle(fontSize: 16.0),
            code: const TextStyle(fontSize: 16.0),
          ),
          onTapLink: (String text, String? href, String title) {
            if (href != null) {
              window.open(href, '_blank');
            }
          },
        ),
      ]),
    ]);
  }
}
