// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserInfoResponse _$$_UserInfoResponseFromJson(Map<String, dynamic> json) =>
    _$_UserInfoResponse(
      uuid: json['user_uuid'] as String,
      email: json['user_email_id'] as String,
      name: json['user_name'] as String,
      phoneNumber: json['user_phone_number'] as String,
      studentId: json['student_id'] as String,
    );

Map<String, dynamic> _$$_UserInfoResponseToJson(_$_UserInfoResponse instance) =>
    <String, dynamic>{
      'user_uuid': instance.uuid,
      'user_email_id': instance.email,
      'user_name': instance.name,
      'user_phone_number': instance.phoneNumber,
      'student_id': instance.studentId,
    };
