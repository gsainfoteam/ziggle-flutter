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
