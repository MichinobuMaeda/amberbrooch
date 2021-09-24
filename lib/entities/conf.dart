part of amberbrooch;

class Conf extends BaseEntity {
  final String url;
  final String policy;

  Conf({
    required String id,
    required this.url,
    required this.policy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  operator ==(Object other) =>
      other is Conf &&
      other.url == url &&
      other.policy == policy &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => hashValues(
        url,
        policy,
        createdAt,
        updatedAt,
      );
}
