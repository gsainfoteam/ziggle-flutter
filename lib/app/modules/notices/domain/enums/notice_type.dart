import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import 'notice_sort.dart';

enum NoticeType {
  all,
  hot,
  recruit(1),
  event(2),
  general(3),
  academic,
  written,
  reminded;

  const NoticeType([this._tagId]);
  final int? _tagId;
  int get tagId => _tagId!;

  static const writable = [recruit, event, general];
  static const tags = [...writable, academic];
  static const sections = [all, hot, ...tags];

  SvgGenImage get icon => {
        all: Assets.icons.clock,
        hot: Assets.icons.fireFlame,
        recruit: Assets.icons.community,
        event: Assets.icons.flower,
        general: Assets.icons.messageAlert,
        academic: Assets.icons.openBook,
        written: Assets.icons.editPencil,
        reminded: Assets.icons.bell,
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
