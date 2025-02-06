import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';

class NoticeGroupEntity {
  final String? uuid;
  final String? name;
  final String? description;
  final DateTime? createdAt;
  final String? presidentUuid;
  final int? memberCount;
  final DateTime? verifiedAt;
  final bool? verified;
  final DateTime? deletedAt;
  final String? notionPageId;
  final String? profileImageKey;

  NoticeGroupEntity({
    this.uuid,
    this.name,
    this.description,
    this.createdAt,
    this.presidentUuid,
    this.memberCount,
    this.verifiedAt,
    this.verified,
    this.deletedAt,
    this.notionPageId,
    this.profileImageKey,
  });

  factory NoticeGroupEntity.fromGroupModel(GroupEntity model) {
    return NoticeGroupEntity(
      uuid: model.uuid,
      name: model.name,
      description: model.description,
      createdAt: model.createdAt,
      presidentUuid: model.presidentUuid,
      memberCount: model.memberCount,
      verifiedAt: model.verifiedAt,
      verified: model.verified,
      deletedAt: model.deletedAt,
      notionPageId: model.notionPageId,
      profileImageKey: model.profileImageKey,
    );
  }
}
