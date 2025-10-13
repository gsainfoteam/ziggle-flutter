import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel implements UserEntity {
  const UserModel._();
  const factory UserModel({
    required String email,
    required String name,
    @JsonKey(name: 'studentNumber') String? studentId,
    required String uuid,
    @Default(true) bool consent,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
