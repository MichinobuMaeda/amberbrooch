import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import "package:universal_html/html.dart" as html;
import 'router.dart';

// SizedBox gutter = const SizedBox(width: 24.0, height: 24.0);

class PrimaryButton extends Widget {
  final IconData iconData;
  final String label;
  final bool disabled;
  final VoidCallback onPressed;

  const PrimaryButton({
    Key? key,
    required this.iconData,
    required this.label,
    this.disabled = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Element createElement() {
    return ElevatedButton.icon(
      icon: Icon(iconData),
      label: Text(label),
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 48),
      ),
    ).createElement();
  }
}

class ContentBody extends Widget {
  final List<Widget> children;
  const ContentBody(
    this.children, {
    Key? key,
  }) : super(key: key);

  @override
  Element createElement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ).createElement();
  }
}

class FlexRow extends Widget {
  final double spacing;
  final double runSpacing;
  final List<Widget> children;

  const FlexRow(
    this.children, {
    Key? key,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  }) : super(key: key);

  @override
  Element createElement() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: children,
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
      title: Text(appTitle),
      actions: [
        IconButton(
          icon: Image.asset('images/logo.png'),
          iconSize: 40.0,
          onPressed: () {
            pushRoute(AppRoutePath.preferences());
          },
        )
      ],
    ).createElement();
  }
}

class PageTitle extends Widget {
  final String title;
  final IconData iconData;
  final bool appOutdated;

  const PageTitle({
    Key? key,
    required this.title,
    required this.iconData,
    required this.appOutdated,
  }) : super(key: key);

  @override
  Element createElement() {
    return FlexRow([
      if (appOutdated)
        Row(
          children: const [Flexible(child: AppUpdateButton())],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      Icon(iconData, size: 32.0),
      Text(title, style: const TextStyle(fontSize: 24.0)),
    ]).createElement();
  }
}

class LoadingStatus extends Widget {
  final String message;
  final Color? color;
  final bool appOutdated;
  final List<Widget> subsequents;

  const LoadingStatus({
    Key? key,
    required this.message,
    required this.appOutdated,
    this.color,
    this.subsequents = const [],
  }) : super(key: key);

  @override
  Element createElement() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
            if (appOutdated) const Center(child: AppUpdateButton()),
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
        minimumSize: const Size(300.0, 48.0),
        primary: Colors.redAccent,
      ),
      onPressed: () => html.window.location.reload(),
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
            width: 48.0,
            height: 48.0,
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
