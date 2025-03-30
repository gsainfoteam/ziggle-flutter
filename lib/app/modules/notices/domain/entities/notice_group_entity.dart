import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';

part 'notice_group_entity.freezed.dart';
part 'notice_group_entity.g.dart';

@freezed
class NoticeGroupEntity with _$NoticeGroupEntity {
  const NoticeGroupEntity._();

  const factory NoticeGroupEntity({
    required String? uuid,
    required String? name,
    required String? description,
    required DateTime? createdAt,
    required String? presidentUuid,
    required int? memberCount,
    required DateTime? verifiedAt,
    required bool? verified,
    required DateTime? deletedAt,
    required String? notionPageId,
    required String? profileImageKey,
  }) = _NoticeGroupEntity;

  factory NoticeGroupEntity.fromJson(Map<String, dynamic> json) =>
      _$NoticeGroupEntityFromJson(json);

  factory NoticeGroupEntity.fromGroupModel(GroupEntity model) {
    return NoticeGroupEntity(
      uuid: model.uuid,
      name: model.name,
      description: model.description,
      createdAt: model.createdAt,
      presidentUuid: model.presidentUuid,
      memberCount: model.memberCount ?? 0,
      verifiedAt: model.verifiedAt,
      verified: model.verified ?? false,
      deletedAt: model.deletedAt,
      notionPageId: model.notionPageId,
      profileImageKey: model.profileImageKey,
    );
  }
}
