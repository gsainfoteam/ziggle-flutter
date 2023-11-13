import 'package:injectable/injectable.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/entities/notice_list_entity.dart';
import '../../domain/entities/notice_search_query_entity.dart';
import '../../domain/entities/notice_summary_entity.dart';
import '../../domain/repositories/notices_repository.dart';
import '../data_sources/notice_api.dart';

@Injectable(as: NoticesRepository)
class RestNoticesRepository implements NoticesRepository {
  final NoticeApi _api;
  RestNoticesRepository(this._api);

  @override
  Future<void> cancelReminder(NoticeEntity notice) {
    return _api.cancelReminder(notice.id);
  }

  @override
  Future<NoticeEntity> getNotice(NoticeSummaryEntity summary) {
    return _api.getNotice(summary.id);
  }

  @override
  Future<NoticeListEntity> getNotices(NoticeSearchQueryEntity query) {
    return _api.getNotices(
      offset: query.offset,
      limit: query.limit,
      search: query.search,
      tags: query.tags,
      orderBy: query.orderBy,
      my: query.my,
    );
  }

  @override
  Future<void> setReminder(NoticeEntity notice) {
    return _api.setReminder(notice.id);
  }
}
