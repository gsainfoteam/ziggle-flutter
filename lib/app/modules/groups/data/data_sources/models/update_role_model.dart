import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_role_model.freezed.dart';

@freezed
sealed class UpdateRoleModel with _$UpdateRoleModel {
  factory UpdateRoleModel({
    required List<String> authorities,
  }) = _UpdateRoleModel;

  factory UpdateRoleModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateRoleModelFromJson(json);
}
