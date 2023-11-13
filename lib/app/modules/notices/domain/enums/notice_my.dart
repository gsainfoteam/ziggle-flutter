import 'package:get/get.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

enum NoticeMy {
  own(NoticeType.my),
  reminders(NoticeType.reminders);

  final NoticeType type;

  const NoticeMy(this.type);
}

extension NoticeTypeMyExtension on NoticeType {
  NoticeMy? get my => NoticeMy.values.firstWhereOrNull((e) => e.type == this);
}
