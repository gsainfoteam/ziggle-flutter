import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

part 'notice_write_draft_entity.freezed.dart';

@freezed
class NoticeWriteDraftEntity with _$NoticeWriteDraftEntity {
  const NoticeWriteDraftEntity._();

  const factory NoticeWriteDraftEntity({
    @Default({}) Map<Language, String> titles,
    @Default({}) Map<Language, String> bodies,
    @Default([]) List<File> images,
    NoticeType? type,
    @Default([]) List<String> tags,
    DateTime? deadline,
    @Default({}) Map<Language, String> additionalContent,
  }) = _NoticeWriteDraftEntity;

  bool get isValid =>
      (!titles.empty(Language.ko)) &&
      (!bodies.empty(Language.ko)) &&
      type != null;
}

extension _LanguageContentX on Map<Language, String> {
  bool empty(Language locale) => !containsKey(locale) || this[locale]!.isEmpty;
}
