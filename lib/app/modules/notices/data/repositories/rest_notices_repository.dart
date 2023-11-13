import 'package:ziggle/app/modules/notices/data/data_sources/notice_api.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_list_entity.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_summary_entity.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_my.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_sort.dart';

import '../../domain/repositories/notices_repository.dart';

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
  Future<NoticeListEntity> getNotices({
    int? offset,
    int? limit,
    String? search,
    List<String>? tags,
    NoticeSort? orderBy,
    NoticeMy? my,
  }) {
    return _api.getNotices(
      offset: offset,
      limit: limit,
      search: search,
      tags: tags,
      orderBy: orderBy,
      my: my,
    );
  }

  @override
  Future<void> setReminder(NoticeEntity notice) {
    return _api.setReminder(notice.id);
  }
}
