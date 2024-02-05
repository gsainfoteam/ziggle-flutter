import 'package:flutter/material.dart';
import 'package:ziggle/app/values/emojis.dart';
import 'package:ziggle/gen/assets.gen.dart';

enum NoticeReation {
  like('\u{1F525}'), // 🔥
  crying('\u{1F622}'), // 😢
  surprised('\u{1F62E}'), // 😮
  thinking('\u{1F914}'), // 🤔
  sad('\u{1F627}'); // 😧

  const NoticeReation(this.emoji);
  final String emoji;

  Widget icon([bool isSelected = false]) {
    switch (this) {
      case NoticeReation.like:
        return Assets.icons.fireFlame.svg(
          colorFilter: isSelected
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null,
        );
      case NoticeReation.crying:
        return const Icon(Emojis.crying);
      case NoticeReation.surprised:
        return const Icon(Emojis.surprised);
      case NoticeReation.thinking:
        return const Icon(Emojis.thinking);
      case NoticeReation.sad:
        return const Icon(Emojis.anguished);
    }
  }
}
