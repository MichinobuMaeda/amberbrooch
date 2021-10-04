import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('entities/Conf: each params has given value.', () {
    final int msec = DateTime.now().millisecondsSinceEpoch;
    Conf conf = Conf(
      id: 'id01',
      version: 'v1.1.0',
      url: 'url01',
      policy: 'policy01',
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );

    expect(conf.id, 'id01');
    expect(conf.version, 'v1.1.0');
    expect(conf.url, 'url01');
    expect(conf.policy, 'policy01');
    expect(conf.createdAt, DateTime.fromMillisecondsSinceEpoch(msec + 1));
    expect(conf.updatedAt, DateTime.fromMillisecondsSinceEpoch(msec + 2));
  });
  test('entities/Conf: fromFirestoreDoc casts Firestore document.', () async {
    final int msec = DateTime.now().millisecondsSinceEpoch;
    final db = FakeFirebaseFirestore();
    await db.collection('service').doc('conf').set({
      'version': 'v1.1.0',
      'url': 'url01',
      'policy': 'policy01',
      'createdAt': DateTime.fromMillisecondsSinceEpoch(msec + 1),
      'updatedAt': DateTime.fromMillisecondsSinceEpoch(msec + 2),
    });
    Conf conf = Conf.fromFirestoreDoc(
      await db.collection('service').doc('conf').get(),
    );

    expect(conf.id, 'conf');
    expect(conf.version, 'v1.1.0');
    expect(conf.url, 'url01');
    expect(conf.policy, 'policy01');
    expect(conf.createdAt, DateTime.fromMillisecondsSinceEpoch(msec + 1));
    expect(conf.updatedAt, DateTime.fromMillisecondsSinceEpoch(msec + 2));
  });
  test('entities/Conf: == evaluate values not references.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Conf conf01 = Conf(
      id: 'id01',
      version: 'v1.1.0',
      url: 'url01',
      policy: 'policy01',
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );
    Conf conf02 = Conf(
      id: 'id01',
      version: 'v1.1.0',
      url: 'url01',
      policy: 'policy01',
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );

    expect(conf01 == conf02, true);
    expect(conf01.hashCode == conf02.hashCode, true);
  });
}
