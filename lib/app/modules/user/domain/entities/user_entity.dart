class UserEntity {
  final String email;
  final String name;
  final String? studentId;
  final String uuid;
  final bool consent;

  UserEntity({
    required this.email,
    required this.name,
    required this.studentId,
    required this.consent,
    required this.uuid,
  });
}
