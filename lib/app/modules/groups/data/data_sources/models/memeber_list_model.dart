import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/data/data_sources/models/member_model.dart';
import 'package:ziggle/app/modules/groups/domain/entities/member_list_entity.dart';

part 'memeber_list_model.freezed.dart';
part 'memeber_list_model.g.dart';

@freezed
class MemeberListModel with _$MemeberListModel implements MemberListEntity {
  factory MemeberListModel(List<MemberModel> list) = _MemeberListModel;

  factory MemeberListModel.fromJson(Map<String, dynamic> json) =>
      _$MemeberListModelFromJson(json);
}
