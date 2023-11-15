import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

class NoticeWriteEntity {
  final String title;
  final String body;
  final DateTime? deadline;
  final Iterable<String> imagePaths;
  final List<String> tags;
  final NoticeType? type;

  const NoticeWriteEntity({
    this.title = "",
    this.body = "",
    this.deadline,
    this.imagePaths = const [],
    this.tags = const [],
    this.type,
  });
}
