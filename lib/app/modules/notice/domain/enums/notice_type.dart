import 'package:ziggle/gen/assets.gen.dart';

enum NoticeType {
  recruit,
  event,
  general;

  SvgGenImage get icon {
    switch (this) {
      case NoticeType.recruit:
        return Assets.icons.recruit;
      case NoticeType.event:
        return Assets.icons.event;
      case NoticeType.general:
        return Assets.icons.general;
    }
  }
}
