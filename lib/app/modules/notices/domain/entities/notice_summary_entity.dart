import 'package:ziggle/app/modules/notices/domain/entities/tag_entity.dart';

class NoticeSummaryEntity {
  final int id;
  final String title;
  final String body;
  final String author;
  final int views;
  final DateTime? deadline;
  final DateTime createdAt;
  final String? imageUrl;
  final List<TagEntity> tags;

  NoticeSummaryEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.views,
    required this.deadline,
    required this.createdAt,
    required this.imageUrl,
    required this.tags,
  });
}
