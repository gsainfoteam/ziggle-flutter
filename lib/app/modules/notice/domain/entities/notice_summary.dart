class NoticeSummary {
  final int id;
  final String title;
  final String authorName;
  final DateTime? deadline;
  final String content;
  final List<String> images;
  final int likes;
  final bool authorIsCertificated;

  const NoticeSummary({
    required this.id,
    required this.title,
    required this.authorName,
    required this.deadline,
    required this.content,
    required this.images,
    required this.likes,
    required this.authorIsCertificated,
  });
}
