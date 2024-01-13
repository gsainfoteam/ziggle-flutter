import 'package:ziggle/gen/assets.gen.dart';

enum NoticeType {
  all,
  hot,
  recruit,
  event,
  general,
  academic;

  static const writable = [recruit, event, general];
  static const tags = [...writable, academic];
  static const sections = [all, hot, ...tags];

  AssetGenImage get icon => {
        all: Assets.icons.clock,
        hot: Assets.icons.fireFlame,
        recruit: Assets.icons.community,
        event: Assets.icons.flower,
        general: Assets.icons.messageAlert,
        academic: Assets.icons.openBook,
      }[this]!;
}
