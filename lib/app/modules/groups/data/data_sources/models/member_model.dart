import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/domain/entities/member_entity.dart';

part 'member_model.freezed.dart';
part 'member_model.g.dart';

@freezed
class MemberModel with _$MemberModel implements MemberEntity {
  factory MemberModel({
    required String uuid,
    required String name,
    required String email,
    required String role,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);
}
