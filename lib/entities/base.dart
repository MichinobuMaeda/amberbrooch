part of amberbrooch;

abstract class BaseEntity {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  BaseEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  @override
  operator ==(Object other) =>
      other is BaseEntity &&
      other.id == id &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.updatedAt == deletedAt;

  @override
  int get hashCode => hashValues(
        id,
        createdAt,
        updatedAt,
        deletedAt,
      );
}
