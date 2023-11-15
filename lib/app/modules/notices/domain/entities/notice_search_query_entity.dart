import '../enums/notice_mine.dart';
import '../enums/notice_sort.dart';

class NoticeSearchQueryEntity {
  final int offset;
  final int limit;
  final String? search;
  final List<String>? tags;
  final NoticeSort? orderBy;
  final NoticeMine? my;

  NoticeSearchQueryEntity({
    this.offset = 0,
    this.limit = 10,
    this.search,
    this.tags,
    this.orderBy,
    this.my,
  });

  NoticeSearchQueryEntity copyWith({
    int? offset,
    int? limit,
    String? search,
    List<String>? tags,
    NoticeSort? orderBy,
    NoticeMine? my,
  }) {
    return NoticeSearchQueryEntity(
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      tags: tags ?? this.tags,
      orderBy: orderBy ?? this.orderBy,
      my: my ?? this.my,
    );
  }
}
