import '../../domain/enums/notice_type.dart';

enum NoticeMy {
  own;

  static NoticeMy? fromType(NoticeType type) => {
        NoticeType.written: own,
      }[type];
}
