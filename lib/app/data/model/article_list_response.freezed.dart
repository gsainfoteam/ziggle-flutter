// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ArticleListResponse _$ArticleListResponseFromJson(Map<String, dynamic> json) {
  return _ArticleListResponse.fromJson(json);
}

/// @nodoc
mixin _$ArticleListResponse {
  List<ArticleSummaryResponse> get list => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArticleListResponseCopyWith<ArticleListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleListResponseCopyWith<$Res> {
  factory $ArticleListResponseCopyWith(
          ArticleListResponse value, $Res Function(ArticleListResponse) then) =
      _$ArticleListResponseCopyWithImpl<$Res, ArticleListResponse>;
  @useResult
  $Res call({List<ArticleSummaryResponse> list, int total});
}

/// @nodoc
class _$ArticleListResponseCopyWithImpl<$Res, $Val extends ArticleListResponse>
    implements $ArticleListResponseCopyWith<$Res> {
  _$ArticleListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ArticleSummaryResponse>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ArticleListResponseCopyWith<$Res>
    implements $ArticleListResponseCopyWith<$Res> {
  factory _$$_ArticleListResponseCopyWith(_$_ArticleListResponse value,
          $Res Function(_$_ArticleListResponse) then) =
      __$$_ArticleListResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ArticleSummaryResponse> list, int total});
}

/// @nodoc
class __$$_ArticleListResponseCopyWithImpl<$Res>
    extends _$ArticleListResponseCopyWithImpl<$Res, _$_ArticleListResponse>
    implements _$$_ArticleListResponseCopyWith<$Res> {
  __$$_ArticleListResponseCopyWithImpl(_$_ArticleListResponse _value,
      $Res Function(_$_ArticleListResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? total = null,
  }) {
    return _then(_$_ArticleListResponse(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<ArticleSummaryResponse>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ArticleListResponse implements _ArticleListResponse {
  const _$_ArticleListResponse(
      {required final List<ArticleSummaryResponse> list, required this.total})
      : _list = list;

  factory _$_ArticleListResponse.fromJson(Map<String, dynamic> json) =>
      _$$_ArticleListResponseFromJson(json);

  final List<ArticleSummaryResponse> _list;
  @override
  List<ArticleSummaryResponse> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  final int total;

  @override
  String toString() {
    return 'ArticleListResponse(list: $list, total: $total)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ArticleListResponse &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_list), total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ArticleListResponseCopyWith<_$_ArticleListResponse> get copyWith =>
      __$$_ArticleListResponseCopyWithImpl<_$_ArticleListResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ArticleListResponseToJson(
      this,
    );
  }
}

abstract class _ArticleListResponse implements ArticleListResponse {
  const factory _ArticleListResponse(
      {required final List<ArticleSummaryResponse> list,
      required final int total}) = _$_ArticleListResponse;

  factory _ArticleListResponse.fromJson(Map<String, dynamic> json) =
      _$_ArticleListResponse.fromJson;

  @override
  List<ArticleSummaryResponse> get list;
  @override
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$_ArticleListResponseCopyWith<_$_ArticleListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
