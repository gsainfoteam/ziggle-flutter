import 'package:flutter/material.dart';
import 'package:ziggle/gen/strings.g.dart';

extension DateTimeX on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String getTimeAgo(BuildContext context) {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inDays > 7) {
      return context.t.notice.calendar.weeksAgo(n: diff.inDays ~/ 7);
    }
    if (diff.inDays > 0) {
      return context.t.notice.calendar.daysAgo(n: diff.inDays);
    }
    if (diff.inHours > 0) {
      return context.t.notice.calendar.hoursAgo(n: diff.inHours);
    }
    if (diff.inMinutes > 0) {
      return context.t.notice.calendar.minutesAgo(n: diff.inMinutes);
    }
    return context.t.notice.calendar.secondsAgo(n: diff.inSeconds);
  }
}
