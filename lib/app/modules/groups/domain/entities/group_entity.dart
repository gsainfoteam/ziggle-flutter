class GroupEntity {
  final String uuid;
  final String name;
  final String description;
  final DateTime createdAt;
  final String presidentUuid;
  final int? memberCount;
  final DateTime? verifiedAt;
  final bool? verified;
  final DateTime? deletedAt;
  final String? notionPageId;
  final String? profileImageKey;

  GroupEntity({
    required this.uuid,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.presidentUuid,
    required this.memberCount,
    required this.verifiedAt,
    required this.verified,
    required this.deletedAt,
    required this.notionPageId,
    required this.profileImageKey,
  });
}
