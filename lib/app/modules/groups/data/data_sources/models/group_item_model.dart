import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_entity.dart';
import 'package:ziggle/app/modules/groups/domain/entities/president_entity.dart';

part 'group_item_model.freezed.dart';
part 'group_item_model.g.dart';

@freezed
class GroupItemModel with _$GroupItemModel implements GroupEntity {
  const GroupItemModel._();

  const factory GroupItemModel({
    required String uuid,
    required String name,
    required String description,
    required DateTime createdAt,
    required String presidentUuid,
    required DateTime? verifiedAt,
    required bool? verified,
    required DateTime? deletedAt,
    required String? notionPageId,
    required String? profileImageKey,
    required String? profileImageUrl,
  }) = _GroupModel;

  factory GroupItemModel.fromJson(Map<String, dynamic> json) =>
      _$GroupItemModelFromJson(json);

  @override
  PresidentEntity? get president => null;

  @override
  int? get memberCount => null;
}
