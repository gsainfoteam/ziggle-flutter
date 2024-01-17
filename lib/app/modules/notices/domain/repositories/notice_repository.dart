import '../entities/notice_entity.dart';
import '../entities/notice_list_entity.dart';

abstract class NoticeRepository {
  Future<NoticeListEntity> getNotices({
    int? offset,
    int? limit,
    String? search,
    List<String>? tags,
  });

  Future<NoticeEntity> getNotice(int id);
}
