class MemberEntity {
  final String uuid;
  final String name;
  final String email;
  final DateTime createdAt;
  final String role;

  MemberEntity({
    required this.uuid,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.role,
  });
}
