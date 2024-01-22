import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

import '../entities/notice_entity.dart';
import '../entities/notice_list_entity.dart';

abstract class NoticeRepository {
  Future<NoticeListEntity> getNotices({
    int? offset,
    int? limit,
    String? search,
    List<String> tags = const [],
    NoticeType type = NoticeType.all,
  });

  Future<NoticeEntity> getNotice(int id);
}
