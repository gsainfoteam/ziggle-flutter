import 'package:ziggle/app/data/enums/notice_sort.dart';

enum ArticleType {
  deadline('⭐️', '기한 임박', 0, sort: NoticeSort.deadline),
  hot('🔥', '요즘 끓는 공지', 0, sort: NoticeSort.hot),
  recruit('🎯', '모집', 1),
  event('🎈', '행사', 2),
  general('🔔', '일반', 3),
  academic('📰', '학사공지', 4, shortTitle: '학사');

  final String emoji;
  final String title;
  final String shortTitle;
  final int id;
  final NoticeSort sort;
  String get label => '$emoji $shortTitle';

  static const searchables = [recruit, event, general, academic];
  static const writables = [recruit, event, general];

  const ArticleType(this.emoji, this.title, this.id,
      {String? shortTitle, NoticeSort? sort})
      : shortTitle = shortTitle ?? title,
        sort = sort ?? NoticeSort.recent;
}
