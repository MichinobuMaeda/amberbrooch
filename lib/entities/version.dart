part of amberbrooch;

class Version extends BaseEntity {
  final String version;
  final String buildNumber;

  Version({
    required String id,
    required this.version,
    required this.buildNumber,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  operator ==(Object other) =>
      other is Version &&
      other.version == version &&
      other.buildNumber == buildNumber &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => hashValues(
        version,
        buildNumber,
        createdAt,
        updatedAt,
      );
}
