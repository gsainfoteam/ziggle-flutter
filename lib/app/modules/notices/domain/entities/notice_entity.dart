import 'tag_entity.dart';

class NoticeEntity {
  final int id;
  final String title;
  final int views;
  final String body;
  final DateTime? deadline;
  final DateTime createdAt;
  final List<String> imagesUrl;
  final List<TagEntity> tags;
  final String author;
  final bool reminder;

  NoticeEntity({
    required this.id,
    this.title = "",
    this.views = 0,
    this.body = "",
    this.deadline,
    required this.createdAt,
    this.imagesUrl = const [],
    this.tags = const [],
    this.author = "",
    this.reminder = false,
  });
}
