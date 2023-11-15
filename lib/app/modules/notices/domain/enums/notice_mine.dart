import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

enum NoticeMine {
  own(NoticeType.my),
  reminders(NoticeType.reminders);

  final NoticeType type;

  const NoticeMine(this.type);
}

extension NoticeTypeMyExtension on NoticeType {
  NoticeMine? get mine =>
      NoticeMine.values.where((e) => e.type == this).firstOrNull;
}
