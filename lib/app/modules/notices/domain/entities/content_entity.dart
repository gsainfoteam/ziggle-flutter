class ContentEntity {
  final int id;
  final String lang;
  final String? title;
  final String body;
  final DateTime? deadline;
  final DateTime createdAt;

  ContentEntity({
    required this.id,
    this.lang = "ko",
    this.title,
    this.body = "",
    this.deadline,
    required this.createdAt,
  });
}
