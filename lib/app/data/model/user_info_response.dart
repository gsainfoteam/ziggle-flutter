// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_response.freezed.dart';
part 'user_info_response.g.dart';

@freezed
class UserInfoResponse with _$UserInfoResponse {
  const factory UserInfoResponse({
    @JsonKey(name: 'user_uuid') required String uuid,
    @JsonKey(name: 'user_email_id') required String email,
    @JsonKey(name: 'user_name') required String name,
    @JsonKey(name: 'student_id') required String studentId,
  }) = _UserInfoResponse;

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UserInfoResponseFromJson(json);
}
