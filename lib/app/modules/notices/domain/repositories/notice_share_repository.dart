import '../entities/notice_entity.dart';

abstract class NoticeShareRepository {
  Future<bool> shareNotice(NoticeEntity notice);
}
