import 'package:collection/collection.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeContentEntity {
  const NoticeContentEntity({
    required this.id,
    required this.lang,
    required this.title,
    required this.body,
    this.deadline,
    required this.createdAt,
  });

  final int id;
  final AppLocale lang;
  final String title;
  final String body;
  final DateTime? deadline;
  final DateTime createdAt;
}

extension NoticeContentsEntityX on List<NoticeContentEntity> {
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
