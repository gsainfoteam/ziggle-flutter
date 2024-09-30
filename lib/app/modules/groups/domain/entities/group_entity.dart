class GroupEntity {
  final String uuid;
  final String name;
  final String description;
  final DateTime createdAt;
  final int president;
  final int memberCount;
  final DateTime? verifiedAt;
  final bool verified;
  final String notionPageId;
  final String? profileImageKey;

  GroupEntity({
    required this.uuid,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.president,
    required this.memberCount,
    required this.verifiedAt,
    required this.verified,
    required this.notionPageId,
    required this.profileImageKey,
  });
}
