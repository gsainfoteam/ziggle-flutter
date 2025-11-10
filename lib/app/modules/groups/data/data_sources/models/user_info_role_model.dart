import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/external_permission_model.dart';

part 'user_info_role_model.freezed.dart';
part 'user_info_role_model.g.dart';

@freezed
sealed class UserInfoRoleModel with _$UserInfoRoleModel {
  const factory UserInfoRoleModel({
    required List<ExternalPermissionModel> externalPermissions,
    required String name,
    required String id,
    required String groupUuid,
    required List<String> permissions,
  }) = _UserInfoRoleModel;

  factory UserInfoRoleModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoRoleModelFromJson(json);
}
