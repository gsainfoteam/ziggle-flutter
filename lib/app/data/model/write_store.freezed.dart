// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'write_store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$WriteStore {
  @HiveField(0)
  String get title => throw _privateConstructorUsedError;
  @HiveField(1)
  String get body => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime? get deadline => throw _privateConstructorUsedError;
  @HiveField(3)
  Iterable<String> get imagePaths => throw _privateConstructorUsedError;
  @HiveField(4)
  List<String> get tags => throw _privateConstructorUsedError;
  @HiveField(5)
  ArticleType? get type => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WriteStoreCopyWith<WriteStore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WriteStoreCopyWith<$Res> {
  factory $WriteStoreCopyWith(
          WriteStore value, $Res Function(WriteStore) then) =
      _$WriteStoreCopyWithImpl<$Res, WriteStore>;
  @useResult
  $Res call(
      {@HiveField(0) String title,
      @HiveField(1) String body,
      @HiveField(2) DateTime? deadline,
      @HiveField(3) Iterable<String> imagePaths,
      @HiveField(4) List<String> tags,
      @HiveField(5) ArticleType? type});
}

/// @nodoc
class _$WriteStoreCopyWithImpl<$Res, $Val extends WriteStore>
    implements $WriteStoreCopyWith<$Res> {
  _$WriteStoreCopyWithImpl(this._value, this._then);

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
    Object? imagePaths = null,
    Object? tags = null,
    Object? type = freezed,
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
      imagePaths: null == imagePaths
          ? _value.imagePaths
          : imagePaths // ignore: cast_nullable_to_non_nullable
              as Iterable<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ArticleType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WriteStoreCopyWith<$Res>
    implements $WriteStoreCopyWith<$Res> {
  factory _$$_WriteStoreCopyWith(
          _$_WriteStore value, $Res Function(_$_WriteStore) then) =
      __$$_WriteStoreCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String title,
      @HiveField(1) String body,
      @HiveField(2) DateTime? deadline,
      @HiveField(3) Iterable<String> imagePaths,
      @HiveField(4) List<String> tags,
      @HiveField(5) ArticleType? type});
}

/// @nodoc
class __$$_WriteStoreCopyWithImpl<$Res>
    extends _$WriteStoreCopyWithImpl<$Res, _$_WriteStore>
    implements _$$_WriteStoreCopyWith<$Res> {
  __$$_WriteStoreCopyWithImpl(
      _$_WriteStore _value, $Res Function(_$_WriteStore) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? body = null,
    Object? deadline = freezed,
    Object? imagePaths = null,
    Object? tags = null,
    Object? type = freezed,
  }) {
    return _then(_$_WriteStore(
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
      imagePaths: null == imagePaths
          ? _value.imagePaths
          : imagePaths // ignore: cast_nullable_to_non_nullable
              as Iterable<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ArticleType?,
    ));
  }
}

/// @nodoc

@HiveType(typeId: 0)
class _$_WriteStore extends _WriteStore {
  const _$_WriteStore(
      {@HiveField(0) required this.title,
      @HiveField(1) required this.body,
      @HiveField(2) required this.deadline,
      @HiveField(3) required this.imagePaths,
      @HiveField(4) required final List<String> tags,
      @HiveField(5) required this.type})
      : _tags = tags,
        super._();

  @override
  @HiveField(0)
  final String title;
  @override
  @HiveField(1)
  final String body;
  @override
  @HiveField(2)
  final DateTime? deadline;
  @override
  @HiveField(3)
  final Iterable<String> imagePaths;
  final List<String> _tags;
  @override
  @HiveField(4)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @HiveField(5)
  final ArticleType? type;

  @override
  String toString() {
    return 'WriteStore(title: $title, body: $body, deadline: $deadline, imagePaths: $imagePaths, tags: $tags, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WriteStore &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            const DeepCollectionEquality()
                .equals(other.imagePaths, imagePaths) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      body,
      deadline,
      const DeepCollectionEquality().hash(imagePaths),
      const DeepCollectionEquality().hash(_tags),
      type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WriteStoreCopyWith<_$_WriteStore> get copyWith =>
      __$$_WriteStoreCopyWithImpl<_$_WriteStore>(this, _$identity);
}

abstract class _WriteStore extends WriteStore {
  const factory _WriteStore(
      {@HiveField(0) required final String title,
      @HiveField(1) required final String body,
      @HiveField(2) required final DateTime? deadline,
      @HiveField(3) required final Iterable<String> imagePaths,
      @HiveField(4) required final List<String> tags,
      @HiveField(5) required final ArticleType? type}) = _$_WriteStore;
  const _WriteStore._() : super._();

  @override
  @HiveField(0)
  String get title;
  @override
  @HiveField(1)
  String get body;
  @override
  @HiveField(2)
  DateTime? get deadline;
  @override
  @HiveField(3)
  Iterable<String> get imagePaths;
  @override
  @HiveField(4)
  List<String> get tags;
  @override
  @HiveField(5)
  ArticleType? get type;
  @override
  @JsonKey(ignore: true)
  _$$_WriteStoreCopyWith<_$_WriteStore> get copyWith =>
      throw _privateConstructorUsedError;
}
