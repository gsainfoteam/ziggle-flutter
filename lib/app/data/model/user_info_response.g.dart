// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserInfoResponse _$$_UserInfoResponseFromJson(Map<String, dynamic> json) =>
    _$_UserInfoResponse(
      userUuid: json['user_uuid'] as String,
      userEmailId: json['user_email_id'] as String,
      userName: json['user_name'] as String,
      userPhoneNumber: json['user_phone_number'] as String,
      studentId: json['student_id'] as String,
    );

Map<String, dynamic> _$$_UserInfoResponseToJson(_$_UserInfoResponse instance) =>
    <String, dynamic>{
      'user_uuid': instance.userUuid,
      'user_email_id': instance.userEmailId,
      'user_name': instance.userName,
      'user_phone_number': instance.userPhoneNumber,
      'student_id': instance.studentId,
    };
