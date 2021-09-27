import 'package:flutter_test/flutter_test.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('entities/Account: params not required have default value.', () {
    int msec = DateTime.now().millisecondsSinceEpoch;
    Account account = Account(
      id: "id01",
      name: "name01",
      // group: null,
      valid: true,
      admin: false,
      tester: false,
      // invitation: null,
      // invitedBy: null,
      // invitedAt: null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
      // deletedAt: null,
    );

    expect(account.id, "id01");
    expect(account.name, "name01");
    expect(account.group, null);
    expect(account.valid, true);
    expect(account.admin, false);
    expect(account.tester, false);
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
      id: "id01",
      name: "name01",
      valid: true,
      admin: false,
      tester: false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );
    Account account02 = Account(
      id: "id01",
      name: "name01",
      valid: true,
      admin: false,
      tester: false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(msec + 1),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(msec + 2),
    );

    expect(account01 == account02, true);
    expect(account01.hashCode == account02.hashCode, true);
  });
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:amberbrooch/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // final TopState topState = tester.state(find.byType(TopScreen));

    // // Build our app and trigger a frame.
    // await tester.pumpWidget(App());

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
//   });
// }
