// member_list_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/member_model.dart';
import 'package:ziggle/app/modules/groups/domain/entities/member_list_entity.dart';

part 'member_list_model.freezed.dart';
part 'member_list_model.g.dart';

@freezed
class MemberListModel with _$MemberListModel implements MemberListEntity {
  factory MemberListModel({
    required List<MemberModel> list,
  }) = _MemberListModel;

  factory MemberListModel.fromJson(Map<String, dynamic> json) =>
      _$MemberListModelFromJson(json);
}
