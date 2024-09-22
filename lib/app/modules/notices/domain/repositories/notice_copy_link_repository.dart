import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';

abstract class NoticeCopyLinkRepository {
  Future<bool> copyLink(NoticeEntity notice);
}
