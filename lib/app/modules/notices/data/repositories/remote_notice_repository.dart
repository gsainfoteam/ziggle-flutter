import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_sort.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_list_entity.dart';
import '../../domain/repositories/notice_repository.dart';
import '../data_sources/remote/notice_api.dart';

@Injectable(as: NoticeRepository)
class RemoteNoticeRepository implements NoticeRepository {
  final NoticeApi _api;

  RemoteNoticeRepository(this._api);

  @override
  Future<NoticeListEntity> getNotices({
    int? offset,
    int? limit,
    String? search,
    List<String>? tags,
  }) {
    return _api.getNotices(
      offset: offset,
      limit: limit,
      search: search,
      tags: tags,
      lang: LocaleSettings.currentLocale,
      orderBy: NoticeSort.recent,
    );
  }
}
