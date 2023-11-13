import 'tag_entity.dart';

class ArticleEntity {
  final int id;
  final String title;
  final int views;
  final String body;
  final DateTime? deadline;
  final DateTime createdAt;
  final List<String>? imagesUrl;
  final List<TagEntity> tags;
  final String author;
  final bool reminder;

  ArticleEntity({
    required this.id,
    required this.title,
    required this.views,
    required this.body,
    this.deadline,
    required this.createdAt,
    this.imagesUrl,
    this.tags = const [],
    required this.author,
    required this.reminder,
  });
}
