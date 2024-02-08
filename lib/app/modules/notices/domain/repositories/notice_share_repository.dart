import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';

abstract class NoticeShareRepository {
  Future<bool> shareNotice(NoticeEntity notice);
}
