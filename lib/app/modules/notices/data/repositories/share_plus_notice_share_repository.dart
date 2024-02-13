import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_share_repository.dart';

@Injectable(as: NoticeShareRepository)
class SharePlusNoticeShareRepository implements NoticeShareRepository {
  @override
  Future<bool> shareNotice(NoticeEntity notice) async {
    final result = await Share.shareWithResult(t.notice.shareContent(
      title: notice.title,
      link: 'https://ziggle.gistory.me/notice/${notice.id}',
    ));
    return result.status == ShareResultStatus.success;
  }
}
