import 'package:ziggle/app/data/enums/notice_sort.dart';
import 'package:ziggle/app/data/model/tag_response.dart';

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
  String get header => '$emoji $title';
  String get label => '$emoji $shortTitle';
  bool get isHorizontal => this == deadline;

  static const searchables = [recruit, event, general, academic];
  static const writables = [recruit, event, general];

  const ArticleType(this.emoji, this.title, this.id,
      {String? shortTitle, NoticeSort? sort})
      : shortTitle = shortTitle ?? title,
        sort = sort ?? NoticeSort.recent;
}

extension TagResponseExtention on TagResponse {
  bool get isType => ArticleType.searchables.map((e) => e.id).contains(id);
}
