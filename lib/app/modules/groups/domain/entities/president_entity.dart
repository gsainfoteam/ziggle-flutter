class PresidentEntity {
  final String uuid;
  final String? name;
  final String? email;
  final DateTime? createdAt;

  PresidentEntity({
    required this.uuid,
    required this.name,
    required this.email,
    required this.createdAt,
  });
}
