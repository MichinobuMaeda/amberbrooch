part of amberbrooch;

class ClientModel extends ChangeNotifier {
  final String deepLink;
  PackageInfo? _packageInfo;

  ClientModel(this.deepLink);

  set packageInfo(PackageInfo? packageInfo) {
    _packageInfo = packageInfo;
    notifyListeners();
  }

  PackageInfo? get packageInfo => _packageInfo;
}
