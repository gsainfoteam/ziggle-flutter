// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel implements UserEntity {
  const UserModel._();
  const factory UserModel({
    required String email,
    required String name,
    @JsonKey(name: 'student_id') String? id,
    @JsonKey(name: 'studentNumber') String? number,
    required String uuid,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  String get studentId => (id ?? number)!;
}
