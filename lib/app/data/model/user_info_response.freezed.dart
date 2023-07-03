// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserInfoResponse _$UserInfoResponseFromJson(Map<String, dynamic> json) {
  return _UserInfoResponse.fromJson(json);
}

/// @nodoc
mixin _$UserInfoResponse {
  String get userUuid => throw _privateConstructorUsedError;
  String get userEmailId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get userPhoneNumber => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserInfoResponseCopyWith<UserInfoResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoResponseCopyWith<$Res> {
  factory $UserInfoResponseCopyWith(
          UserInfoResponse value, $Res Function(UserInfoResponse) then) =
      _$UserInfoResponseCopyWithImpl<$Res, UserInfoResponse>;
  @useResult
  $Res call(
      {String userUuid,
      String userEmailId,
      String userName,
      String userPhoneNumber,
      String studentId});
}

/// @nodoc
class _$UserInfoResponseCopyWithImpl<$Res, $Val extends UserInfoResponse>
    implements $UserInfoResponseCopyWith<$Res> {
  _$UserInfoResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userUuid = null,
    Object? userEmailId = null,
    Object? userName = null,
    Object? userPhoneNumber = null,
    Object? studentId = null,
  }) {
    return _then(_value.copyWith(
      userUuid: null == userUuid
          ? _value.userUuid
          : userUuid // ignore: cast_nullable_to_non_nullable
              as String,
      userEmailId: null == userEmailId
          ? _value.userEmailId
          : userEmailId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userPhoneNumber: null == userPhoneNumber
          ? _value.userPhoneNumber
          : userPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserInfoResponseCopyWith<$Res>
    implements $UserInfoResponseCopyWith<$Res> {
  factory _$$_UserInfoResponseCopyWith(
          _$_UserInfoResponse value, $Res Function(_$_UserInfoResponse) then) =
      __$$_UserInfoResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userUuid,
      String userEmailId,
      String userName,
      String userPhoneNumber,
      String studentId});
}

/// @nodoc
class __$$_UserInfoResponseCopyWithImpl<$Res>
    extends _$UserInfoResponseCopyWithImpl<$Res, _$_UserInfoResponse>
    implements _$$_UserInfoResponseCopyWith<$Res> {
  __$$_UserInfoResponseCopyWithImpl(
      _$_UserInfoResponse _value, $Res Function(_$_UserInfoResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userUuid = null,
    Object? userEmailId = null,
    Object? userName = null,
    Object? userPhoneNumber = null,
    Object? studentId = null,
  }) {
    return _then(_$_UserInfoResponse(
      userUuid: null == userUuid
          ? _value.userUuid
          : userUuid // ignore: cast_nullable_to_non_nullable
              as String,
      userEmailId: null == userEmailId
          ? _value.userEmailId
          : userEmailId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userPhoneNumber: null == userPhoneNumber
          ? _value.userPhoneNumber
          : userPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserInfoResponse implements _UserInfoResponse {
  const _$_UserInfoResponse(
      {required this.userUuid,
      required this.userEmailId,
      required this.userName,
      required this.userPhoneNumber,
      required this.studentId});

  factory _$_UserInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$$_UserInfoResponseFromJson(json);

  @override
  final String userUuid;
  @override
  final String userEmailId;
  @override
  final String userName;
  @override
  final String userPhoneNumber;
  @override
  final String studentId;

  @override
  String toString() {
    return 'UserInfoResponse(userUuid: $userUuid, userEmailId: $userEmailId, userName: $userName, userPhoneNumber: $userPhoneNumber, studentId: $studentId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserInfoResponse &&
            (identical(other.userUuid, userUuid) ||
                other.userUuid == userUuid) &&
            (identical(other.userEmailId, userEmailId) ||
                other.userEmailId == userEmailId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userPhoneNumber, userPhoneNumber) ||
                other.userPhoneNumber == userPhoneNumber) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userUuid, userEmailId, userName, userPhoneNumber, studentId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserInfoResponseCopyWith<_$_UserInfoResponse> get copyWith =>
      __$$_UserInfoResponseCopyWithImpl<_$_UserInfoResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserInfoResponseToJson(
      this,
    );
  }
}

abstract class _UserInfoResponse implements UserInfoResponse {
  const factory _UserInfoResponse(
      {required final String userUuid,
      required final String userEmailId,
      required final String userName,
      required final String userPhoneNumber,
      required final String studentId}) = _$_UserInfoResponse;

  factory _UserInfoResponse.fromJson(Map<String, dynamic> json) =
      _$_UserInfoResponse.fromJson;

  @override
  String get userUuid;
  @override
  String get userEmailId;
  @override
  String get userName;
  @override
  String get userPhoneNumber;
  @override
  String get studentId;
  @override
  @JsonKey(ignore: true)
  _$$_UserInfoResponseCopyWith<_$_UserInfoResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
