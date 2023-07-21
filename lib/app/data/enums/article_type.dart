import 'package:ziggle/app/data/enums/notice_sort.dart';
import 'package:ziggle/app/data/model/tag_response.dart';

enum ArticleType {
  deadline('⭐️', '기한 임박', '마감 시간이 일주일도 안 남은 공지를\n모아서 보여 드려요',
      sort: NoticeSort.deadline),
  hot('🔥', '요즘 끓는 공지', '지난 일주일 동안 조회수가 150이 넘은 공지들이\n여기서 지글지글 끓고 있어요',
      sort: NoticeSort.hot),
  my('🔥', '내가 쓴 공지', '내가 쓴 공지들을 모아서 보여 드려요'),
  reminders('🔔', '리마인더 설정한 공지', '알림을 설정한 공지들을 모아서 보여 드려요'),
  recruit('🎯', '모집', '언제나 여러분께 열린 기회', id: 1),
  event('🎈', '행사', '지스트는 오늘도 뜨겁습니다', id: 2),
  general('🔔', '일반', '지스트인들이 해야 하는 일들', id: 3),
  academic('📰', '학사공지', '지스트인이 해야 하는 일들', id: 4, shortTitle: '학사');

  final String emoji;
  final String title;
  final String shortTitle;
  final String description;
  final int id;
  final NoticeSort sort;
  String get header => '$emoji $title';
  String get label => '$emoji $shortTitle';
  bool get isHorizontal => this == deadline;
  bool get isSearchable => searchables.contains(this);

  static const writables = [recruit, event, general];
  static const searchables = [...writables, academic];
  static const main = [deadline, hot, ...searchables];
  static const profile = [my, reminders];

  const ArticleType(this.emoji, this.title, this.description,
      {this.id = 0, String? shortTitle, NoticeSort? sort})
      : shortTitle = shortTitle ?? title,
        sort = sort ?? NoticeSort.recent;
}

extension TagResponseExtention on TagResponse {
  bool get isType => ArticleType.searchables.map((e) => e.id).contains(id);
  TagResponse get type => copyWith(
        name: ArticleType.searchables.firstWhere((e) => e.id == id).shortTitle,
      );
}
