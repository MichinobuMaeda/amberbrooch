part of amberbrooch;

class Conf extends BaseEntity {
  final String version;
  final String url;
  final String policy;

  Conf({
    required String id,
    required this.version,
    required this.url,
    required this.policy,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory Conf.fromFirestoreDoc(dynamic doc) => Conf(
        id: doc.id,
        version: doc.get('version'),
        url: doc.get('url'),
        policy: doc.get('policy'),
        createdAt: doc.get('createdAt').toDate(),
        updatedAt: doc.get('updatedAt').toDate(),
      );

  @override
  operator ==(Object other) =>
      other is Conf &&
      other.version == version &&
      other.url == url &&
      other.policy == policy &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => hashValues(
        version,
        url,
        policy,
        createdAt,
        updatedAt,
      );
}
