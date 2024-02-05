import '../entities/notice_entity.dart';
import '../entities/notice_list_entity.dart';
import '../enums/notice_type.dart';

abstract class NoticeRepository {
  Future<NoticeListEntity> getNotices({
    int? offset,
    int? limit,
    String? search,
    List<String> tags = const [],
    NoticeType type = NoticeType.all,
  });

  Future<NoticeEntity> getNotice(int id);

  Future<NoticeEntity> addReaction(int id, String emoji);
}
