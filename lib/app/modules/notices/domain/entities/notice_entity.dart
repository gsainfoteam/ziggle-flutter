import 'notice_content_entity.dart';

class NoticeEntity {
  final int id;
  final int views;
  final DateTime? currentDeadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List tags;
  final List<NoticeContentEntity> contents;
  final List reactions;
  final String author;
  final List<String> imagesUrl;
  final List<String> documentsUrl;

  NoticeEntity({
    required this.id,
    required this.views,
    required this.currentDeadline,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.tags,
    required this.contents,
    required this.reactions,
    required this.author,
    required this.imagesUrl,
    required this.documentsUrl,
  });

  factory NoticeEntity.fromId(int id) => NoticeEntity(
        id: id,
        views: 0,
        currentDeadline: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
        tags: [],
        contents: [],
        reactions: [],
        imagesUrl: [],
        documentsUrl: [],
        author: '',
      );
}
