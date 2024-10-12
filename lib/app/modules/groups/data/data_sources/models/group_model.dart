import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
class GroupModel with _$GroupModel implements GroupEntity {
  const GroupModel._();

  const factory GroupModel({
    required String uuid,
    required String name,
    required String description,
    required DateTime createdAt,
    required String presidentUuid,
    required int memberCount,
    required DateTime? verifiedAt,
    required bool verified,
    required DateTime? deletedAt,
    required String? notionPageId,
    required String? profileImageKey,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
}
