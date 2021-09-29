import 'package:flutter_test/flutter_test.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('entities/Version: each params has given value.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Conf version = Conf(
      id: "id01",
      version: "v1.1.0",
      buildNumber: "1",
      url: "url01",
      policy: "policy01",
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );

    expect(version.id, "id01");
    expect(version.version, "v1.1.0");
    expect(version.buildNumber, "1");
    expect(version.url, "url01");
    expect(version.policy, "policy01");
    expect(version.createdAt, DateTime.fromMillisecondsSinceEpoch(msec + 1));
    expect(version.updatedAt, DateTime.fromMillisecondsSinceEpoch(msec + 2));
  });

  test('entities/Version: == evaluate values not references.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Conf version01 = Conf(
      id: "id01",
      version: "v1.1.0",
      buildNumber: "1",
      url: "url01",
      policy: "policy01",
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );
    Conf version02 = Conf(
      id: "id01",
      version: "v1.1.0",
      buildNumber: "1",
      url: "url01",
      policy: "policy01",
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );

    expect(version01 == version02, true);
    expect(version01.hashCode == version02.hashCode, true);
  });
}
