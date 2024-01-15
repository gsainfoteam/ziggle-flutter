class NoticeEntity {
  final int id;
  final int views;
  final DateTime? currentDeadline;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List tags;
  final List contents;
  final List reactions;
  final String author;
  final List<String> imagesUrl;
  final List<String> documentsUrl;

  @Deprecated('use contents')
  final String title;
  @Deprecated('use contents')
  final String body;

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
    required this.title,
    required this.body,
  });
}
