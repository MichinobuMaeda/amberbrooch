import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('entities/Account: params not required have default value.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Account account = Account(
      id: 'id01',
      name: 'name01',
      valid: true,
      admin: false,
      tester: false,
      // themeMode: ThemeMode.light,
      // invitation: null,
      // invitedBy: null,
      // invitedAt: null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
      // deletedAt: null,
    );

    expect(account.id, 'id01');
    expect(account.name, 'name01');
    expect(account.valid, true);
    expect(account.admin, false);
    expect(account.tester, false);
    expect(account.themeMode, ThemeMode.light);
    expect(account.invitation, null);
    expect(account.invitedBy, null);
    expect(account.invitedAt, null);
    expect(account.createdAt, DateTime.fromMillisecondsSinceEpoch(msec + 1));
    expect(account.updatedAt, DateTime.fromMillisecondsSinceEpoch(msec + 2));
    expect(account.deletedAt, null);
  });
  test('entities/Account: fromFirestoreDoc casts Firestore document.',
      () async {
    final int msec = DateTime.now().millisecondsSinceEpoch;
    final db = FakeFirebaseFirestore();
    await db.collection('accounts').doc('id01').set({
      'name': 'name01',
      'valid': true,
      'admin': false,
      'tester': false,
      'invitation': null,
      'invitedBy': null,
      'invitedAt': null,
      'createdAt': DateTime.fromMillisecondsSinceEpoch(msec + 1),
      'updatedAt': DateTime.fromMillisecondsSinceEpoch(msec + 2),
      'deletedAt': null,
    });
    Account account = Account.fromFirestoreDoc(
      await db.collection('accounts').doc('id01').get(),
    );

    expect(account.id, 'id01');
    expect(account.name, 'name01');
    expect(account.valid, true);
    expect(account.admin, false);
    expect(account.tester, false);
    expect(account.themeMode, ThemeMode.light);
    expect(account.invitation, null);
    expect(account.invitedBy, null);
    expect(account.invitedAt, null);
    expect(account.createdAt, DateTime.fromMillisecondsSinceEpoch(msec + 1));
    expect(account.updatedAt, DateTime.fromMillisecondsSinceEpoch(msec + 2));
    expect(account.deletedAt, null);
  });
  test('entities/Account: == evaluate values not references.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Account account01 = Account(
      id: 'id01',
      name: 'name01',
      valid: true,
      admin: false,
      tester: false,
      themeMode: ThemeMode.dark,
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );
    Account account02 = Account(
      id: 'id01',
      name: 'name01',
      valid: true,
      admin: false,
      tester: false,
      themeMode: ThemeMode.dark,
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );

    expect(account01 == account02, true);
    expect(account01.hashCode == account02.hashCode, true);
  });
}
