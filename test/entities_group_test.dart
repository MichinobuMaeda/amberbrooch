import 'package:flutter_test/flutter_test.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('entities/Group: params not required have default value.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Group group = Group(
      id: "id01",
      name: "name01",
      desc: "desc01",
      accounts: ["id01", "id02"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
      // deletedAt: null,
    );

    expect(group.id, "id01");
    expect(group.name, "name01");
    expect(group.desc, "desc01");
    expect(group.accounts, ["id01", "id02"]);
    expect(group.createdAt, DateTime.fromMillisecondsSinceEpoch(msec + 1));
    expect(group.updatedAt, DateTime.fromMillisecondsSinceEpoch(msec + 2));
    expect(group.deletedAt, null);
  });

  test('entities/Group: == evaluate values not references.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Group group01 = Group(
      id: "id01",
      name: "name01",
      desc: "desc01",
      accounts: ["id01", "id02"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
      // deletedAt: null,
    );
    Group group02 = Group(
      id: "id01",
      name: "name01",
      desc: "desc01",
      accounts: ["id01", "id02"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
      // deletedAt: null,
    );

    expect(group01 == group02, true);
    expect(group01.hashCode == group02.hashCode, true);
  });
}
