part of amberbrooch;

class Account extends BaseEntity {
  final String name;
  final bool valid;
  final bool admin;
  final bool tester;
  final String? invitation;
  final String? invitedBy;
  final DateTime? invitedAt;

  Account({
    required String id,
    required this.name,
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

  factory Account.fromFirestoreDoc(dynamic doc) => Account(
        id: doc.id,
        name: doc.get('name'),
        valid: doc.get('valid'),
        admin: doc.get('admin'),
        tester: doc.get('tester'),
        invitation: doc.get('invitation'),
        invitedBy: doc.get('invitedBy'),
        invitedAt: doc.get('invitedAt')?.toDate(),
        createdAt: doc.get('createdAt').toDate(),
        updatedAt: doc.get('updatedAt').toDate(),
        deletedAt: doc.get('deletedAt')?.toDate(),
      );

  @override
  operator ==(Object other) =>
      other is Account &&
      other.id == id &&
      other.name == name &&
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
