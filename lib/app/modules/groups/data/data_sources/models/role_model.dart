import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/domain/entities/role_entity.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

@freezed
sealed class RoleModel with _$RoleModel implements RoleEntity {
  factory RoleModel({
    required int id,
    required String name,
    required String groupUuid,
    required List<String> authorities,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);
}
