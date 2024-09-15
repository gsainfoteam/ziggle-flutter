import 'package:json_annotation/json_annotation.dart';
import 'package:ziggle/app/modules/notices/domain/enums/notice_type.dart';
import 'package:ziggle/gen/strings.g.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum NoticeCategory {
  academic,
  recruit,
  event,
  club,
  etc;

  String get name => t.notice.category(context: this);
  static NoticeCategory? fromType(NoticeType type) => {
        NoticeType.academic: NoticeCategory.academic,
        NoticeType.recruit: NoticeCategory.recruit,
        NoticeType.event: NoticeCategory.event,
        NoticeType.general: NoticeCategory.etc,
      }[type];
}
