import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';

enum NoticeSort {
  deadline,
  recent,
  hot;

  static NoticeSort fromType(NoticeType type) =>
      {
        NoticeType.deadline: NoticeSort.deadline,
        NoticeType.hot: NoticeSort.hot,
      }[type] ??
      NoticeSort.recent;
}
