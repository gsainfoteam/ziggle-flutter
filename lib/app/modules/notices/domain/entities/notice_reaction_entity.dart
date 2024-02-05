class NoticeReactionEntity {
  final String emoji;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final int noticeId;
  final String userId;

  NoticeReactionEntity({
    required this.emoji,
    required this.createdAt,
    required this.deletedAt,
    required this.noticeId,
    required this.userId,
  });
}
