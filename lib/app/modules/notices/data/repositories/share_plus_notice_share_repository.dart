import 'package:share_plus/share_plus.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_content_entity.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_share_repository.dart';

class SharePlusNoticeShareRepository implements NoticeShareRepository {
  @override
  Future<bool> shareNotice(NoticeEntity notice) async {
    final result = await Share.shareWithResult(t.notice.shareContent(
      title: notice.contents.main.title,
      link: 'https://ziggle.gistory.me/notice/${notice.id}',
    ));
    return result.status == ShareResultStatus.success;
  }
}
