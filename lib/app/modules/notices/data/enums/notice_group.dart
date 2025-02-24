import '../../domain/enums/notice_type.dart';

enum NoticeGroup {
  own;

  static NoticeGroup? fromType(NoticeType type) => {
        NoticeType.written: own,
      }[type];
}
