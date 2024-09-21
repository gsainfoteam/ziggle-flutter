import 'package:collection/collection.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeContentEntity {
  const NoticeContentEntity({
    required this.id,
    required this.lang,
    required this.content,
    this.deadline,
    required this.createdAt,
  });

  final int id;
  final AppLocale lang;
  final String content;
  final DateTime? deadline;
  final DateTime createdAt;
}

extension NoticeContentsEntityX on Iterable<NoticeContentEntity> {
  Iterable<NoticeContentEntity> localesBy(AppLocale locale) =>
      where((e) => e.lang == locale);
  Iterable<NoticeContentEntity> get locales =>
      groupFoldBy<int, NoticeContentEntity>(
        (element) => element.id,
        (p, e) => e.lang == LocaleSettings.currentLocale || p == null ? e : p,
      ).values;
  NoticeContentEntity get main => locales.firstWhere((e) => e.id == 1);
  Iterable<NoticeContentEntity> get additionals => locales.where(
        (e) => e.id != 1,
      );
}
