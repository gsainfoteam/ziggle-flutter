import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/data/data_sources/remote/notice_api.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_list_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_repository.dart';
import 'package:ziggle/gen/strings.g.dart';

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
    );
  }
}
