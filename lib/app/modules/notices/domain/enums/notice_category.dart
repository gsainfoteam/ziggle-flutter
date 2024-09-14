import 'package:json_annotation/json_annotation.dart';
import 'package:ziggle/gen/strings.g.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum NoticeCategory {
  academic,
  recruit,
  event,
  club,
  etc;

  String get name => t.notice.category(context: this);
}
