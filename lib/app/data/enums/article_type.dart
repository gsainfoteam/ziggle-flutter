import 'package:ziggle/app/data/enums/notice_sort.dart';
import 'package:ziggle/app/data/model/tag_response.dart';
import 'package:ziggle/gen/strings.g.dart';

enum ArticleType {
  recruit('🎯', id: 1),
  event('🎈', id: 2),
  general('🔔', id: 3),
  academic('📰', id: 4),
  all('🫧'),
  deadline('⭐️', sort: NoticeSort.deadline),
  hot('🔥', sort: NoticeSort.hot),
  my('🔥'),
  reminders('🔔');

  final String emoji;
  String get title => t.article.section.title(type: this);
  String get shortTitle => t.article.section.shortTitle(type: this);
  String get description => t.article.section.description(type: this);
  final int id;
  final NoticeSort sort;
  String get header => '$emoji $title';
  String get label => '$emoji $shortTitle';
  bool get noPreview => this == all;
  bool get isHorizontal => this == deadline;
  bool get isSearchable => searchables.contains(this);
  bool get isProfile => profile.contains(this);

  static const writables = [recruit, event, general];
  static const searchables = [...writables, academic];
  static const main = [all, deadline, hot, ...searchables];
  static const profile = [my, reminders];

  const ArticleType(this.emoji, {this.id = 0, NoticeSort? sort})
      : sort = sort ?? NoticeSort.recent;
}

extension TagResponseExtention on TagResponse {
  bool get isType => ArticleType.searchables.map((e) => e.id).contains(id);
  TagResponse get type => copyWith(
        name: ArticleType.searchables.firstWhere((e) => e.id == id).shortTitle,
      );
}
