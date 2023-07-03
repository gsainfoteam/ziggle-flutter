// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TagResponse _$TagResponseFromJson(Map<String, dynamic> json) {
  return _TagResponse.fromJson(json);
}

/// @nodoc
mixin _$TagResponse {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagResponseCopyWith<TagResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagResponseCopyWith<$Res> {
  factory $TagResponseCopyWith(
          TagResponse value, $Res Function(TagResponse) then) =
      _$TagResponseCopyWithImpl<$Res, TagResponse>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$TagResponseCopyWithImpl<$Res, $Val extends TagResponse>
    implements $TagResponseCopyWith<$Res> {
  _$TagResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TagResponseCopyWith<$Res>
    implements $TagResponseCopyWith<$Res> {
  factory _$$_TagResponseCopyWith(
          _$_TagResponse value, $Res Function(_$_TagResponse) then) =
      __$$_TagResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$_TagResponseCopyWithImpl<$Res>
    extends _$TagResponseCopyWithImpl<$Res, _$_TagResponse>
    implements _$$_TagResponseCopyWith<$Res> {
  __$$_TagResponseCopyWithImpl(
      _$_TagResponse _value, $Res Function(_$_TagResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$_TagResponse(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TagResponse implements _TagResponse {
  const _$_TagResponse({required this.id, required this.name});

  factory _$_TagResponse.fromJson(Map<String, dynamic> json) =>
      _$$_TagResponseFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'TagResponse(id: $id, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TagResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TagResponseCopyWith<_$_TagResponse> get copyWith =>
      __$$_TagResponseCopyWithImpl<_$_TagResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TagResponseToJson(
      this,
    );
  }
}

abstract class _TagResponse implements TagResponse {
  const factory _TagResponse(
      {required final int id, required final String name}) = _$_TagResponse;

  factory _TagResponse.fromJson(Map<String, dynamic> json) =
      _$_TagResponse.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$_TagResponseCopyWith<_$_TagResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
