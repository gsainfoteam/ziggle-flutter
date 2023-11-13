import '../enums/notice_my.dart';
import '../enums/notice_sort.dart';

class NoticeSearchQueryEntity {
  final int? offset;
  final int? limit;
  final String? search;
  final List<String>? tags;
  final NoticeSort? orderBy;
  final NoticeMy? my;

  NoticeSearchQueryEntity({
    this.offset,
    this.limit,
    this.search,
    this.tags,
    this.orderBy,
    this.my,
  });
}
