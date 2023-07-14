// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_summary_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ArticleSummaryResponse _$ArticleSummaryResponseFromJson(
    Map<String, dynamic> json) {
  return _ArticleSummaryResponse.fromJson(json);
}

/// @nodoc
mixin _$ArticleSummaryResponse {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  int get views => throw _privateConstructorUsedError;
  DateTime? get deadline => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<TagResponse> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArticleSummaryResponseCopyWith<ArticleSummaryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleSummaryResponseCopyWith<$Res> {
  factory $ArticleSummaryResponseCopyWith(ArticleSummaryResponse value,
          $Res Function(ArticleSummaryResponse) then) =
      _$ArticleSummaryResponseCopyWithImpl<$Res, ArticleSummaryResponse>;
  @useResult
  $Res call(
      {int id,
      String title,
      String body,
      String author,
      int views,
      DateTime? deadline,
      DateTime createdAt,
      String? imageUrl,
      List<TagResponse> tags});
}

/// @nodoc
class _$ArticleSummaryResponseCopyWithImpl<$Res,
        $Val extends ArticleSummaryResponse>
    implements $ArticleSummaryResponseCopyWith<$Res> {
  _$ArticleSummaryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? author = null,
    Object? views = null,
    Object? deadline = freezed,
    Object? createdAt = null,
    Object? imageUrl = freezed,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      views: null == views
          ? _value.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<TagResponse>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ArticleSummaryResponseCopyWith<$Res>
    implements $ArticleSummaryResponseCopyWith<$Res> {
  factory _$$_ArticleSummaryResponseCopyWith(_$_ArticleSummaryResponse value,
          $Res Function(_$_ArticleSummaryResponse) then) =
      __$$_ArticleSummaryResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String body,
      String author,
      int views,
      DateTime? deadline,
      DateTime createdAt,
      String? imageUrl,
      List<TagResponse> tags});
}

/// @nodoc
class __$$_ArticleSummaryResponseCopyWithImpl<$Res>
    extends _$ArticleSummaryResponseCopyWithImpl<$Res,
        _$_ArticleSummaryResponse>
    implements _$$_ArticleSummaryResponseCopyWith<$Res> {
  __$$_ArticleSummaryResponseCopyWithImpl(_$_ArticleSummaryResponse _value,
      $Res Function(_$_ArticleSummaryResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? author = null,
    Object? views = null,
    Object? deadline = freezed,
    Object? createdAt = null,
    Object? imageUrl = freezed,
    Object? tags = null,
  }) {
    return _then(_$_ArticleSummaryResponse(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      views: null == views
          ? _value.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<TagResponse>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.none)
class _$_ArticleSummaryResponse implements _ArticleSummaryResponse {
  const _$_ArticleSummaryResponse(
      {required this.id,
      required this.title,
      required this.body,
      required this.author,
      required this.views,
      required this.deadline,
      required this.createdAt,
      required this.imageUrl,
      final List<TagResponse> tags = const []})
      : _tags = tags;

  factory _$_ArticleSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$$_ArticleSummaryResponseFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String body;
  @override
  final String author;
  @override
  final int views;
  @override
  final DateTime? deadline;
  @override
  final DateTime createdAt;
  @override
  final String? imageUrl;
  final List<TagResponse> _tags;
  @override
  @JsonKey()
  List<TagResponse> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'ArticleSummaryResponse(id: $id, title: $title, body: $body, author: $author, views: $views, deadline: $deadline, createdAt: $createdAt, imageUrl: $imageUrl, tags: $tags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ArticleSummaryResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      body,
      author,
      views,
      deadline,
      createdAt,
      imageUrl,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ArticleSummaryResponseCopyWith<_$_ArticleSummaryResponse> get copyWith =>
      __$$_ArticleSummaryResponseCopyWithImpl<_$_ArticleSummaryResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ArticleSummaryResponseToJson(
      this,
    );
  }
}

abstract class _ArticleSummaryResponse implements ArticleSummaryResponse {
  const factory _ArticleSummaryResponse(
      {required final int id,
      required final String title,
      required final String body,
      required final String author,
      required final int views,
      required final DateTime? deadline,
      required final DateTime createdAt,
      required final String? imageUrl,
      final List<TagResponse> tags}) = _$_ArticleSummaryResponse;

  factory _ArticleSummaryResponse.fromJson(Map<String, dynamic> json) =
      _$_ArticleSummaryResponse.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get body;
  @override
  String get author;
  @override
  int get views;
  @override
  DateTime? get deadline;
  @override
  DateTime get createdAt;
  @override
  String? get imageUrl;
  @override
  List<TagResponse> get tags;
  @override
  @JsonKey(ignore: true)
  _$$_ArticleSummaryResponseCopyWith<_$_ArticleSummaryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
