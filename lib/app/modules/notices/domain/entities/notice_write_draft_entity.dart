import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/gen/strings.g.dart';

part 'notice_write_draft_entity.freezed.dart';

@freezed
class NoticeWriteDraftEntity with _$NoticeWriteDraftEntity {
  const NoticeWriteDraftEntity._();

  const factory NoticeWriteDraftEntity({
    @Default({}) Map<AppLocale, String> titles,
    @Default({}) Map<AppLocale, String> bodies,
    @Default([]) List<File> images,
    NoticeType? type,
    @Default([]) List<String> tags,
    DateTime? deadline,
  }) = _NoticeWriteDraftEntity;

  bool get isValid =>
      (!titles.empty(AppLocale.ko)) &&
      (!bodies.empty(AppLocale.ko)) &&
      type != null;
}

extension _LanguageContentX on Map<AppLocale, String> {
  bool empty(AppLocale locale) => !containsKey(locale) || this[locale]!.isEmpty;
}
