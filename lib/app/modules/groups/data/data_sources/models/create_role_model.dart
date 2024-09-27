import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_role_model.freezed.dart';

@freezed
sealed class CreateRoleModel with _$CreateRoleModel {
  factory CreateRoleModel({
    required String name,
    required List<String> authorities,
  }) = _CreateRoleModel;

  factory CreateRoleModel.fromJson(Map<String, dynamic> json) =>
      _$CreateRoleModelFromJson(json);
}
