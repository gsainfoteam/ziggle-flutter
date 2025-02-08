import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/groups/domain/entities/group_user_entity.dart';

part 'group_user_model.freezed.dart';
part 'group_user_model.g.dart';

@freezed
class GroupUserModel with _$GroupUserModel implements GroupUserEntity {
  const GroupUserModel._();
  const factory GroupUserModel({
    required String uuid,
    required String name,
    required String email,
    required DateTime createdAt,
  }) = _UserModel;

  factory GroupUserModel.fromJson(Map<String, dynamic> json) =>
      _$GroupUserModelFromJson(json);
}
