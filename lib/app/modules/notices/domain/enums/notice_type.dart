import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import 'notice_sort.dart';

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
  bool get isTag => tags.contains(this);
  String get label => t.notice.type(type: this);
  NoticeSort get defaultSort =>
      {hot: NoticeSort.hot}[this] ?? NoticeSort.recent;

  static NoticeType? fromTag(String tag) => {
        'recruit': recruit,
        'event': event,
        'general': general,
        'academic': academic,
      }[tag];
}
