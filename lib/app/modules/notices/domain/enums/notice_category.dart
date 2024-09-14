import 'package:ziggle/gen/strings.g.dart';

enum NoticeCategory {
  academic,
  recruit,
  event,
  club,
  etc;

  String get name => t.notice.category(context: this);
}
