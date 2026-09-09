import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/user/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@Freezed(fromJson: true)
sealed class UserModel with _$UserModel implements UserEntity {
  const UserModel._();

  @override
  bool get hasConsented => consent != null;

  const factory UserModel({
    required String email,
    required String name,
    @JsonKey(name: 'studentNumber') String? studentId,
    required String uuid,
    DateTime? consent,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json['consent'] is bool) {
      json['consent'] = json['consent']
          ? DateTime.now().toIso8601String()
          : null;
    }
    return _$UserModelFromJson(json);
  }
}
