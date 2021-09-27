import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:amberbrooch/main.dart';

class FakePackageInfo extends Fake implements PackageInfo {}

void main() {
  test('entities/ClientModel: initialized with param: deepLink', () {
    const String url = 'https://example.com/';
    ClientModel clientModel = ClientModel(url);
    expect(clientModel.deepLink, url);
    expect(clientModel.packageInfo, null);
  });
  test('entities/ClientModel: can get/set PackageInfo.', () {
    const String url = 'https://example.com/';
    PackageInfo packageInfo = FakePackageInfo();
    ClientModel clientModel = ClientModel(url);
    expect(clientModel.packageInfo, null);
    clientModel.packageInfo = packageInfo;
    expect(clientModel.packageInfo, packageInfo);
  });
}
