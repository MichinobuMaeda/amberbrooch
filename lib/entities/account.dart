part of amberbrooch;

class Account extends BaseEntity {
  final String name;
  String? group;
  final bool valid;
  final bool admin;
  final bool tester;
  final String? invitation;
  final String? invitedBy;
  final DateTime? invitedAt;

  Account({
    required String id,
    required this.name,
    this.group,
    required this.valid,
    required this.admin,
    required this.tester,
    this.invitation,
    this.invitedBy,
    this.invitedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  @override
  operator ==(Object other) =>
      other is Account &&
      other.id == id &&
      other.name == name &&
      other.group == group &&
      other.valid == valid &&
      other.admin == admin &&
      other.tester == tester &&
      other.invitation == invitation &&
      other.invitedBy == invitedBy &&
      other.invitedAt == invitedAt &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;

  @override
  int get hashCode => hashValues(
        id,
        name,
        group,
        valid,
        admin,
        tester,
        invitation,
        invitedBy,
        invitedAt,
        createdAt,
        updatedAt,
        deletedAt,
      );
}
