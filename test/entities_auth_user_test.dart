import 'package:flutter_test/flutter_test.dart';
import 'package:amberbrooch/main.dart';

void main() {
  test('entities/AuthUser: params not required have default value.', () {
    AuthUser authUser = AuthUser(
      id: "id01",
      // email: null,
      // emailVerified: false,
    );

    expect(authUser.id, "id01");
    expect(authUser.email, null);
    expect(authUser.emailVerified, false);
  });

  test('entities/AuthUser: == evaluate values not references.', () {
    AuthUser authUser01 = AuthUser(
      id: "id01",
      email: "emal01",
      emailVerified: true,
    );
    AuthUser authUser02 = AuthUser(
      id: "id01",
      email: "emal01",
      emailVerified: true,
    );

    expect(authUser01 == authUser02, true);
    expect(authUser01.hashCode == authUser02.hashCode, true);
  });
}
