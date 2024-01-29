import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/data/enums/notice_my.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/entities/notice_list_entity.dart';
import '../../domain/enums/notice_type.dart';
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
    List<String> tags = const [],
    NoticeType type = NoticeType.all,
  }) {
    return _api.getNotices(
      offset: offset,
      limit: limit,
      search: search,
      tags: [if (type.isTag) type.name, ...tags],
      // lang: LocaleSettings.currentLocale,
      orderBy: type.defaultSort,
      my: NoticeMy.fromType(type),
    );
  }

  @override
  Future<NoticeEntity> getNotice(int id) {
    return _api.getNotice(id, isViewed: true);
  }
}
