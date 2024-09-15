import 'package:flutter/material.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

enum NoticeType {
  deadline,
  general,
  event,
  recruit,
  hot,
  academic;

  static List<NoticeType> writable = [recruit, event, general];
  static List<NoticeType> categories = [
    deadline,
    general,
    event,
    recruit,
    hot,
    academic
  ];

  SvgGenImage get icon => {
        NoticeType.recruit: Assets.icons.recruit,
        NoticeType.event: Assets.icons.event,
        NoticeType.general: Assets.icons.general,
      }[this]!;

  AssetGenImage get image => {
        NoticeType.deadline: Assets.images.flash,
        NoticeType.general: Assets.images.megaphone,
        NoticeType.event: Assets.images.gift,
        NoticeType.recruit: Assets.images.target,
        NoticeType.hot: Assets.images.fire,
        NoticeType.academic: Assets.images.book,
      }[this]!;

  Color get textColor => {
        NoticeType.deadline: const Color(0xFFDB785E),
        NoticeType.general: const Color(0xFFA61529),
        NoticeType.event: const Color(0xFF3A3D4A),
        NoticeType.recruit: const Color(0xFFCF3D58),
        NoticeType.hot: const Color(0xFFD88841),
        NoticeType.academic: const Color(0xFF3A3698),
      }[this]!;

  Color get backgroundColor => {
        NoticeType.deadline: const Color(0x33E5A95F),
        NoticeType.general: const Color(0x33AA2032),
        NoticeType.event: const Color(0x3F4E5160),
        NoticeType.recruit: const Color(0x59E1DFDF),
        NoticeType.hot: const Color(0x4CD98942),
        NoticeType.academic: const Color(0x33372CA6),
      }[this]!;

  String getName(BuildContext context) => context.t.notice.type(context: this);
}
