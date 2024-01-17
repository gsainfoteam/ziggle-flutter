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
  Iterable<NoticeContentEntity> get _main => where(
        (element) => element.id == 1,
      );
  Iterable<NoticeContentEntity> get _additionals => where(
        (element) => element.id != 1,
      );
  NoticeContentEntity get localed =>
      _main.firstWhereOrNull(
        (element) => element.lang == LocaleSettings.currentLocale,
      ) ??
      _main.single;

  Iterable<NoticeContentEntity> get additional => _additionals
      .groupFoldBy<int, NoticeContentEntity>(
        (element) => element.id,
        (p, e) => e.lang == LocaleSettings.currentLocale || p == null ? e : p,
      )
      .values;
}
