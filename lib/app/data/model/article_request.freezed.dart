// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ArticleRequest _$ArticleRequestFromJson(Map<String, dynamic> json) {
  return _ArticleRequest.fromJson(json);
}

/// @nodoc
mixin _$ArticleRequest {
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  DateTime? get deadline => throw _privateConstructorUsedError;
  List<int>? get tags => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArticleRequestCopyWith<ArticleRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleRequestCopyWith<$Res> {
  factory $ArticleRequestCopyWith(
          ArticleRequest value, $Res Function(ArticleRequest) then) =
      _$ArticleRequestCopyWithImpl<$Res, ArticleRequest>;
  @useResult
  $Res call(
      {String title,
      String body,
      DateTime? deadline,
      List<int>? tags,
      List<String>? images});
}

/// @nodoc
class _$ArticleRequestCopyWithImpl<$Res, $Val extends ArticleRequest>
    implements $ArticleRequestCopyWith<$Res> {
  _$ArticleRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? deadline = freezed,
    Object? tags = freezed,
    Object? images = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ArticleRequestCopyWith<$Res>
    implements $ArticleRequestCopyWith<$Res> {
  factory _$$_ArticleRequestCopyWith(
          _$_ArticleRequest value, $Res Function(_$_ArticleRequest) then) =
      __$$_ArticleRequestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String body,
      DateTime? deadline,
      List<int>? tags,
      List<String>? images});
}

/// @nodoc
class __$$_ArticleRequestCopyWithImpl<$Res>
    extends _$ArticleRequestCopyWithImpl<$Res, _$_ArticleRequest>
    implements _$$_ArticleRequestCopyWith<$Res> {
  __$$_ArticleRequestCopyWithImpl(
      _$_ArticleRequest _value, $Res Function(_$_ArticleRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? deadline = freezed,
    Object? tags = freezed,
    Object? images = freezed,
  }) {
    return _then(_$_ArticleRequest(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ArticleRequest implements _ArticleRequest {
  const _$_ArticleRequest(
      {required this.title,
      required this.body,
      required this.deadline,
      final List<int>? tags,
      final List<String>? images})
      : _tags = tags,
        _images = images;

  factory _$_ArticleRequest.fromJson(Map<String, dynamic> json) =>
      _$$_ArticleRequestFromJson(json);

  @override
  final String title;
  @override
  final String body;
  @override
  final DateTime? deadline;
  final List<int>? _tags;
  @override
  List<int>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ArticleRequest(title: $title, body: $body, deadline: $deadline, tags: $tags, images: $images)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ArticleRequest &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      body,
      deadline,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_images));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ArticleRequestCopyWith<_$_ArticleRequest> get copyWith =>
      __$$_ArticleRequestCopyWithImpl<_$_ArticleRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ArticleRequestToJson(
      this,
    );
  }
}

abstract class _ArticleRequest implements ArticleRequest {
  const factory _ArticleRequest(
      {required final String title,
      required final String body,
      required final DateTime? deadline,
      final List<int>? tags,
      final List<String>? images}) = _$_ArticleRequest;

  factory _ArticleRequest.fromJson(Map<String, dynamic> json) =
      _$_ArticleRequest.fromJson;

  @override
  String get title;
  @override
  String get body;
  @override
  DateTime? get deadline;
  @override
  List<int>? get tags;
  @override
  List<String>? get images;
  @override
  @JsonKey(ignore: true)
  _$$_ArticleRequestCopyWith<_$_ArticleRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
