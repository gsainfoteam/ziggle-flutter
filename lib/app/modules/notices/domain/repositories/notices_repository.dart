import '../entities/notice_entity.dart';
import '../entities/notice_list_entity.dart';
import '../entities/notice_search_query_entity.dart';
import '../entities/notice_summary_entity.dart';

abstract class NoticesRepository {
  Future<NoticeListEntity> getNotices(NoticeSearchQueryEntity query);
  Future<NoticeEntity> getNotice(NoticeSummaryEntity summary);
  Future<void> setReminder(NoticeEntity notice);
  Future<void> cancelReminder(NoticeEntity notice);
}
