enum ArticleType {
  recruit('🎯', '모집', 1),
  event('🎈', '행사', 1),
  general('🔔', '일반', 1),
  academic('📰', '학사', 1);

  final String emoji;
  final String title;
  final int id;
  String get label => '$emoji $title';

  const ArticleType(this.emoji, this.title, this.id);
}
