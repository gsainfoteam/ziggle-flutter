import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_create_entity.freezed.dart';

@freezed
class GroupCreateEntity with _$GroupCreateEntity {
  const factory GroupCreateEntity({
    @Default('') String name,
    @Default('') String description,
    String? notionPageId,
  }) = _GroupCreateEntity;
}
