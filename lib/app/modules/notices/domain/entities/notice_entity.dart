import 'package:ziggle/app/modules/notices/domain/entities/content_entity.dart';

import 'tag_entity.dart';

class NoticeEntity {
  final int id;
  final int views;
  final DateTime? currentDeadline;
  final DateTime createdAt;
  final List<ContentEntity> contents;
  final List<String> imagesUrl;
  final List<TagEntity> tags;
  final String author;
  final bool reminder;

  NoticeEntity({
    required this.id,
    this.views = 0,
    this.currentDeadline,
    required this.createdAt,
    required this.contents,
    this.imagesUrl = const [],
    this.tags = const [],
    this.author = "",
    this.reminder = false,
  }) : assert(contents.isNotEmpty);
}
