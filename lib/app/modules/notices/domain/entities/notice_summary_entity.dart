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
    this.title = "",
    this.body = "",
    this.author = "",
    this.views = 0,
    this.deadline,
    required this.createdAt,
    this.imageUrl,
    this.tags = const [],
  });
}
