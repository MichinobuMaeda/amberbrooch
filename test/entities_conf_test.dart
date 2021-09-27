import 'package:flutter_test/flutter_test.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('entities/Conf: each params has given value.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Conf conf = Conf(
      id: "id01",
      url: "name01",
      policy: "policy01",
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );

    expect(conf.id, "id01");
    expect(conf.url, "name01");
    expect(conf.policy, "policy01");
    expect(conf.createdAt, DateTime.fromMillisecondsSinceEpoch(msec + 1));
    expect(conf.updatedAt, DateTime.fromMillisecondsSinceEpoch(msec + 2));
  });

  test('entities/Conf: == evaluate values not references.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Conf conf01 = Conf(
      id: "id01",
      url: "name01",
      policy: "policy01",
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );
    Conf conf02 = Conf(
      id: "id01",
      url: "name01",
      policy: "policy01",
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );

    expect(conf01 == conf02, true);
    expect(conf01.hashCode == conf02.hashCode, true);
  });
}
