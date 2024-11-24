import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_create_draft_entity.freezed.dart';

@freezed
class GroupCreateDraftEntity with _$GroupCreateDraftEntity {
  const factory GroupCreateDraftEntity({
    @Default('') String name,
    File? image,
    @Default('') String description,
    String? notionPageId,
  }) = _GroupCreateDraftEntity;
}
