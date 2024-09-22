import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_copy_link_repository.dart';

@Injectable(as: NoticeCopyLinkRepository)
class ClipboardNoticeCopyLinkRepository implements NoticeCopyLinkRepository {
  @override
  Future<bool> copyLink(NoticeEntity notice) async {
    try {
      await Clipboard.setData(ClipboardData(
        text: 'https://ziggle.gistory.me/notice/${notice.id}',
      ));
      return true;
    } catch (e) {
      return false;
    }
  }
}
