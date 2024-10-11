import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

part 'group_user_model.freezed.dart';
part 'group_user_model.g.dart';

@freezed
class GroupUserModel with _$GroupUserModel implements UserEntity {
  const GroupUserModel._();
  const factory GroupUserModel({
    required String email,
    required String name,
    @JsonKey(name: 'studentNumber') required String studentId,
    required String uuid,
  }) = _UserModel;

  factory GroupUserModel.fromJson(Map<String, dynamic> json) =>
      _$GroupUserModelFromJson(json);
}
