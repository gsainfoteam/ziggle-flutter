enum ArticleType {
  deadline('⭐️', '기한 임박', 1),
  hot('🔥', '요즘 끓는 공지', 1),
  recruit('🎯', '모집', 1),
  event('🎈', '행사', 1),
  general('🔔', '일반', 1),
  academic('📰', '학사공지', 1, shortTitle: '학사');

  final String emoji;
  final String title;
  final String shortTitle;
  final int id;
  String get label => '$emoji $shortTitle';

  static const searchables = [recruit, event, general, academic];
  static const writables = [recruit, event, general];

  const ArticleType(this.emoji, this.title, this.id, {String? shortTitle})
      : shortTitle = shortTitle ?? title;
}
