import 'package:flutter/material.dart';
import 'package:ziggle/app/values/emojis.dart';
import 'package:ziggle/gen/assets.gen.dart';

enum NoticeReation {
  like,
  cry,
  wow,
  think,
  sad;

  Widget get icon {
    switch (this) {
      case NoticeReation.like:
        return Assets.icons.fireFlame.svg();
      case NoticeReation.cry:
        return const Icon(Emojis.crying);
      case NoticeReation.wow:
        return const Icon(Emojis.surprised);
      case NoticeReation.think:
        return const Icon(Emojis.thinking);
      case NoticeReation.sad:
        return const Icon(Emojis.anguished);
    }
  }
}
