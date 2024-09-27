import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/group_model.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_list_entity.dart';

part 'group_list_model.freezed.dart';

@freezed
class GroupListModel with _$GroupListModel implements GroupListEntity {
  const GroupListModel._();

  const factory GroupListModel({
    required int total,
    required List<GroupModel> list,
  }) = _GroupListModel;

  factory GroupListModel.fromJson(Map<String, dynamic> json) =>
      _$GroupListModelFromJson(json);
}
