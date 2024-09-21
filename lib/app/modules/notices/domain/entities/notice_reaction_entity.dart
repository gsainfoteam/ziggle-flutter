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

extension NoticeReactionEntityX on NoticeReactionEntity {
  NoticeReactionEntity copyWith({
    String? emoji,
    int? count,
    bool? isReacted,
  }) {
    return NoticeReactionEntity(
      emoji: emoji ?? this.emoji,
      count: count ?? this.count,
      isReacted: isReacted ?? this.isReacted,
    );
  }
}
