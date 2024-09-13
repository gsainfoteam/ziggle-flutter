class NoticeReactionEntity {
  final String emoji;
  final int count;
  final bool isReacted;

  NoticeReactionEntity({
    required this.emoji,
    required this.count,
    required this.isReacted,
  });
}
