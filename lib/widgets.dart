import 'package:flutter/material.dart';
import 'router.dart';

SizedBox gutter = const SizedBox(width: 24.0, height: 24.0);

class PrimaryButton extends Widget {
  final IconData iconData;
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({
    Key? key,
    required this.iconData,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Element createElement() {
    return ElevatedButton.icon(
      icon: Icon(iconData),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 48),
      ),
    ).createElement();
  }
}

class Header extends AppBar {
  final BuildContext context;
  final ValueChanged<AppRoutePath> pushRoute;
  final String appTitle;

  Header({
    Key? key,
    required this.context,
    required this.pushRoute,
    required this.appTitle,
  }) : super(key: key);

  @override
  StatefulElement createElement() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Image.asset('images/logo.png'),
        onPressed: () {
          pushRoute(AppRoutePath.top());
        },
      ),
      title: Text(appTitle),
      actions: const [],
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
    return Row(
      children: [
        Icon(iconData, size: 32.0),
        const SizedBox(width: 4.0),
        Flexible(child: Text(title, style: const TextStyle(fontSize: 24.0))),
      ],
    ).createElement();
  }
}

class LoadingStatus extends Widget {
  final String message;
  final Color? color;
  final List<Widget> subsequents;

  const LoadingStatus({
    Key? key,
    required this.message,
    this.color,
    this.subsequents = const [],
  }) : super(key: key);

  @override
  Element createElement() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
            Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 24.0,
                  color: color,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ] +
          subsequents,
    ).createElement();
  }
}
