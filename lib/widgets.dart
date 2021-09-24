part of amberbrooch;

abstract class _IconButton extends Widget {
  final IconData iconData;
  final String label;
  final bool disabled;
  final VoidCallback onPressed;
  final Color? primary;

  const _IconButton({
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
        minimumSize: const Size(120, 48),
        primary: primary,
      ),
    ).createElement();
  }
}

class PrimaryButton extends _IconButton {
  const PrimaryButton({
    Key? key,
    required IconData iconData,
    required String label,
    bool disabled = false,
    required VoidCallback onPressed,
  }) : super(
          key: key,
          iconData: iconData,
          label: label,
          disabled: disabled,
          onPressed: onPressed,
        );
}

class SecondaryButton extends _IconButton {
  const SecondaryButton({
    Key? key,
    required IconData iconData,
    required String label,
    bool disabled = false,
    required VoidCallback onPressed,
  }) : super(
            key: key,
            iconData: iconData,
            label: label,
            disabled: disabled,
            onPressed: onPressed,
            primary: Colors.blueGrey);
}

class SaveButton extends PrimaryButton {
  const SaveButton({
    Key? key,
    bool disabled = false,
    required VoidCallback onPressed,
  }) : super(
          key: key,
          iconData: Icons.save_alt,
          label: '保存',
          disabled: disabled,
          onPressed: onPressed,
        );
}

class CancelButton extends SecondaryButton {
  const CancelButton({
    Key? key,
    bool disabled = false,
    required VoidCallback onPressed,
  }) : super(
          key: key,
          iconData: Icons.cancel,
          label: '中止',
          disabled: disabled,
          onPressed: onPressed,
        );
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
  final Function realoadApp;

  const PageTitle({
    Key? key,
    required this.title,
    required this.iconData,
    required this.appOutdated,
    required this.realoadApp,
  }) : super(key: key);

  @override
  Element createElement() {
    return FlexRow([
      if (appOutdated)
        Row(
          children: [Flexible(child: AppUpdateButton(realoadApp: realoadApp))],
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
  final Function realoadApp;

  const LoadingStatus({
    Key? key,
    required this.message,
    required this.appOutdated,
    this.color,
    this.subsequents = const [],
    required this.realoadApp,
  }) : super(key: key);

  @override
  Element createElement() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
            if (appOutdated)
              Center(child: AppUpdateButton(realoadApp: realoadApp)),
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
  final Function realoadApp;

  const AppUpdateButton({
    Key? key,
    required this.realoadApp,
  }) : super(key: key);

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
