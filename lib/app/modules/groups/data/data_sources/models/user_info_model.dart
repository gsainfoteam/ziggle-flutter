import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/user_info_role_model.dart';

part 'user_info_model.freezed.dart';
part 'user_info_model.g.dart';

@freezed
sealed class UserInfoModel with _$UserInfoModel {
  const factory UserInfoModel({
    required UserInfoRoleModel role,
    required String name,
    required String description,
    required String uuid,
    required DateTime createdAt,
    required DateTime verifiedAt,
    required String presidentUuid,
    required DateTime deletedAt,
    required String notionPageId,
    required String profileImageKey,
  }) = _UserInfoModel;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);
}
