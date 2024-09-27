import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_model.freezed.dart';

@freezed
sealed class RoleModel with _$RoleModel {
  factory RoleModel({
    required int id,
    required String name,
    required String groupUuid,
    required List<String> authorities,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);
}
