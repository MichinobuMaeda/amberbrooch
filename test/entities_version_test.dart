import 'package:flutter_test/flutter_test.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('entities/Version: each params has given value.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Version version = Version(
      id: "id01",
      version: "v1.1.0",
      buildNumber: "1",
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );

    expect(version.id, "id01");
    expect(version.version, "v1.1.0");
    expect(version.buildNumber, "1");
    expect(version.createdAt, DateTime.fromMillisecondsSinceEpoch(msec + 1));
    expect(version.updatedAt, DateTime.fromMillisecondsSinceEpoch(msec + 2));
  });

  test('entities/Version: == evaluate values not references.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Version version01 = Version(
      id: "id01",
      version: "v1.1.0",
      buildNumber: "1",
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );
    Version version02 = Version(
      id: "id01",
      version: "v1.1.0",
      buildNumber: "1",
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );

    expect(version01 == version02, true);
    expect(version01.hashCode == version02.hashCode, true);
  });
}
