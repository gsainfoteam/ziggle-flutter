import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/role_model.dart';

part 'role_list_model.freezed.dart';
part 'role_list_model.g.dart';

@freezed
sealed class RoleListModel with _$RoleListModel {
  factory RoleListModel(
    List<RoleModel> roleModel,
  ) = _RoleListModel;

  factory RoleListModel.fromJson(Map<String, dynamic> json) =>
      _$RoleListModelFromJson(json);
}
