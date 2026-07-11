import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_group_entity.freezed.dart';
part 'notice_group_entity.g.dart';

@freezed
sealed class NoticeGroupEntity with _$NoticeGroupEntity {
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
}
