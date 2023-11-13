import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_list_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_my.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_sort.dart';

abstract class NoticesRepository {
  Future<NoticeListEntity> getNotices({
    int? offset,
    int? limit,
    String? search,
    List<String>? tags,
    NoticeSort? orderBy,
    NoticeMy? my,
  });
  Future<NoticeEntity> getNotice(NoticeSummaryEntity summary);
  Future<void> setReminder(NoticeEntity notice);
  Future<void> cancelReminder(NoticeEntity notice);
}
