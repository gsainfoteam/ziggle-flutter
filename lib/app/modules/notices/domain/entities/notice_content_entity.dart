import 'package:collection/collection.dart';
import 'package:ziggle/app/modules/core/domain/enums/language.dart';

class NoticeContentEntity {
  const NoticeContentEntity({
    required this.id,
    required this.lang,
    required this.content,
    this.deadline,
    required this.createdAt,
  });

  final int id;
  final Language lang;
  final String content;
  final DateTime? deadline;
  final DateTime createdAt;
}

extension NoticeContentsEntityX on Iterable<NoticeContentEntity> {
  Iterable<NoticeContentEntity> localesBy(Language locale) =>
      where((e) => e.lang == locale);
  Iterable<NoticeContentEntity> get locales =>
      groupFoldBy<int, NoticeContentEntity>(
        (element) => element.id,
        (p, e) => e.lang == Language.getCurrentLanguage() || p == null ? e : p,
      ).values;
  NoticeContentEntity get main => locales.firstWhere((e) => e.id == 1);
  Iterable<NoticeContentEntity> get additionals => locales.where(
        (e) => e.id != 1,
      );
}
