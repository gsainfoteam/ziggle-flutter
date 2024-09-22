import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ziggle/app/modules/notices/domain/entities/notice_entity.dart';
import 'package:ziggle/app/modules/notices/domain/repositories/notice_share_repository.dart';
import 'package:ziggle/gen/strings.g.dart';

@Injectable(as: NoticeShareRepository)
class SharePlusNoticeShareRepository implements NoticeShareRepository {
  @override
  Future<bool> shareNotice(NoticeEntity notice) async {
    final result = await Share.share(t.notice.detail.shareContent(
      title: notice.titles.current,
      link: 'https://ziggle.gistory.me/notice/${notice.id}',
    ));
    return result.status == ShareResultStatus.success;
  }
}
