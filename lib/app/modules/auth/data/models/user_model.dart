// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel implements UserEntity {
  const factory UserModel({
    @JsonKey(name: 'user_uuid') required String id,
    @JsonKey(name: 'user_email_id') required String email,
    @JsonKey(name: 'user_name') required String name,
    @JsonKey(name: 'student_id') required String studentId,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
