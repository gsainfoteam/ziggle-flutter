import '../../domain/enums/notice_type.dart';

enum NoticeMy {
  own,
  reminders;

  static NoticeMy? fromType(NoticeType type) => {
        NoticeType.written: own,
        NoticeType.reminded: reminders,
      }[type];
}
