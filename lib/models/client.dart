part of amberbrooch;

class ClientModel extends ChangeNotifier {
  final String deepLink;
  PackageInfo? _packageInfo;

  ClientModel(this.deepLink);

  void setPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  PackageInfo? get packageInfo => _packageInfo;
}
