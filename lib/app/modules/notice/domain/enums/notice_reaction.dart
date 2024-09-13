import 'package:flutter/material.dart';
import 'package:ziggle/app/values/emojis.dart';
import 'package:ziggle/gen/assets.gen.dart';

enum NoticeReaction {
  like('\u{1F525}'), // 🔥
  crying('\u{1F62D}'), // 😭
  surprised('\u{1F62E}'), // 😮
  thinking('\u{1F914}'), // 🤔
  sad('\u{1F627}'); // 😧

  const NoticeReaction(this.emoji);
  final String emoji;

  Widget icon([bool isSelected = false]) {
    switch (this) {
      case NoticeReaction.like:
        return Assets.icons.fire.svg(
          colorFilter: isSelected
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null,
        );
      case NoticeReaction.crying:
        return const Icon(Emojis.crying);
      case NoticeReaction.surprised:
        return const Icon(Emojis.surprised);
      case NoticeReaction.thinking:
        return const Icon(Emojis.thinking);
      case NoticeReaction.sad:
        return const Icon(Emojis.anguished);
    }
  }
}
