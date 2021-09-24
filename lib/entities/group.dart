part of amberbrooch;

class Group extends BaseEntity {
  final String name;
  final String desc;
  final List<String> accounts;

  Group({
    required String id,
    required this.name,
    required this.desc,
    required this.accounts,
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
      other is Group &&
      other.id == id &&
      other.name == name &&
      other.desc == desc &&
      deepCollectionEquality(other.accounts, accounts) &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.updatedAt == deletedAt;

  @override
  int get hashCode => hashValues(
        id,
        name,
        desc,
        hashList(accounts),
        createdAt,
        updatedAt,
        deletedAt,
      );
}
