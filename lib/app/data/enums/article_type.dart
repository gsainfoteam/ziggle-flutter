enum ArticleType {
  recruit('🎯', '모집'),
  event('🎈', '행사'),
  general('🔔', '일반'),
  academic('📰', '학사');

  final String emoji;
  final String title;
  String get label => '$emoji $title';

  const ArticleType(this.emoji, this.title);
}
