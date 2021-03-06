part of amberbrooch;

class AuthUser {
  final String id;
  String? email;
  final bool emailVerified;

  AuthUser({
    required this.id,
    this.email,
    this.emailVerified = false,
  });

  @override
  operator ==(Object other) =>
      other is AuthUser &&
      other.id == id &&
      other.email == email &&
      other.emailVerified == emailVerified;

  @override
  int get hashCode => hashValues(id, email, emailVerified);
}
