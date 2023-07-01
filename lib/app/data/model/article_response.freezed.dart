// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ArticleResponse _$ArticleResponseFromJson(Map<String, dynamic> json) {
  return _ArticleResponse.fromJson(json);
}

/// @nodoc
mixin _$ArticleResponse {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get views => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  DateTime? get deatline => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<String>? get imagesUrl => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArticleResponseCopyWith<ArticleResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleResponseCopyWith<$Res> {
  factory $ArticleResponseCopyWith(
          ArticleResponse value, $Res Function(ArticleResponse) then) =
      _$ArticleResponseCopyWithImpl<$Res, ArticleResponse>;
  @useResult
  $Res call(
      {int id,
      String title,
      int views,
      String body,
      DateTime? deatline,
      DateTime createdAt,
      List<String>? imagesUrl,
      List<String> tags,
      String author});
}

/// @nodoc
class _$ArticleResponseCopyWithImpl<$Res, $Val extends ArticleResponse>
    implements $ArticleResponseCopyWith<$Res> {
  _$ArticleResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? views = null,
    Object? body = null,
    Object? deatline = freezed,
    Object? createdAt = null,
    Object? imagesUrl = freezed,
    Object? tags = null,
    Object? author = null,
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
      views: null == views
          ? _value.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      deatline: freezed == deatline
          ? _value.deatline
          : deatline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imagesUrl: freezed == imagesUrl
          ? _value.imagesUrl
          : imagesUrl // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ArticleResponseCopyWith<$Res>
    implements $ArticleResponseCopyWith<$Res> {
  factory _$$_ArticleResponseCopyWith(
          _$_ArticleResponse value, $Res Function(_$_ArticleResponse) then) =
      __$$_ArticleResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      int views,
      String body,
      DateTime? deatline,
      DateTime createdAt,
      List<String>? imagesUrl,
      List<String> tags,
      String author});
}

/// @nodoc
class __$$_ArticleResponseCopyWithImpl<$Res>
    extends _$ArticleResponseCopyWithImpl<$Res, _$_ArticleResponse>
    implements _$$_ArticleResponseCopyWith<$Res> {
  __$$_ArticleResponseCopyWithImpl(
      _$_ArticleResponse _value, $Res Function(_$_ArticleResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? views = null,
    Object? body = null,
    Object? deatline = freezed,
    Object? createdAt = null,
    Object? imagesUrl = freezed,
    Object? tags = null,
    Object? author = null,
  }) {
    return _then(_$_ArticleResponse(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      views: null == views
          ? _value.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      deatline: freezed == deatline
          ? _value.deatline
          : deatline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      imagesUrl: freezed == imagesUrl
          ? _value._imagesUrl
          : imagesUrl // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ArticleResponse implements _ArticleResponse {
  const _$_ArticleResponse(
      {required this.id,
      required this.title,
      required this.views,
      required this.body,
      required this.deatline,
      required this.createdAt,
      required final List<String>? imagesUrl,
      required final List<String> tags,
      required this.author})
      : _imagesUrl = imagesUrl,
        _tags = tags;

  factory _$_ArticleResponse.fromJson(Map<String, dynamic> json) =>
      _$$_ArticleResponseFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final int views;
  @override
  final String body;
  @override
  final DateTime? deatline;
  @override
  final DateTime createdAt;
  final List<String>? _imagesUrl;
  @override
  List<String>? get imagesUrl {
    final value = _imagesUrl;
    if (value == null) return null;
    if (_imagesUrl is EqualUnmodifiableListView) return _imagesUrl;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String author;

  @override
  String toString() {
    return 'ArticleResponse(id: $id, title: $title, views: $views, body: $body, deatline: $deatline, createdAt: $createdAt, imagesUrl: $imagesUrl, tags: $tags, author: $author)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ArticleResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.deatline, deatline) ||
                other.deatline == deatline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._imagesUrl, _imagesUrl) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.author, author) || other.author == author));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      views,
      body,
      deatline,
      createdAt,
      const DeepCollectionEquality().hash(_imagesUrl),
      const DeepCollectionEquality().hash(_tags),
      author);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ArticleResponseCopyWith<_$_ArticleResponse> get copyWith =>
      __$$_ArticleResponseCopyWithImpl<_$_ArticleResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ArticleResponseToJson(
      this,
    );
  }
}

abstract class _ArticleResponse implements ArticleResponse {
  const factory _ArticleResponse(
      {required final int id,
      required final String title,
      required final int views,
      required final String body,
      required final DateTime? deatline,
      required final DateTime createdAt,
      required final List<String>? imagesUrl,
      required final List<String> tags,
      required final String author}) = _$_ArticleResponse;

  factory _ArticleResponse.fromJson(Map<String, dynamic> json) =
      _$_ArticleResponse.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  int get views;
  @override
  String get body;
  @override
  DateTime? get deatline;
  @override
  DateTime get createdAt;
  @override
  List<String>? get imagesUrl;
  @override
  List<String> get tags;
  @override
  String get author;
  @override
  @JsonKey(ignore: true)
  _$$_ArticleResponseCopyWith<_$_ArticleResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
