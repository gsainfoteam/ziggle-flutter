import 'package:flutter/material.dart';
import 'package:ziggle/gen/strings.g.dart';

enum NoticeCategory {
  academic,
  recruit,
  event,
  club,
  etc;

  String getName(BuildContext context) =>
      context.t.notice.category(context: this);
}
