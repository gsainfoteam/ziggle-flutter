import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class CreatedAt extends StatefulWidget {
  const CreatedAt({super.key, required this.createdAt});

  final DateTime createdAt;

  @override
  State<CreatedAt> createState() => _CreatedAtState();
}

class _CreatedAtState extends State<CreatedAt> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timeAgo {
    final now = DateTime.now();
    final diff = now.difference(widget.createdAt);
    if (diff.inDays > 7) {
      return t.notice.calendar.weeksAgo(n: diff.inDays ~/ 7);
    }
    if (diff.inDays > 0) {
      return t.notice.calendar.daysAgo(n: diff.inDays);
    }
    if (diff.inHours > 0) {
      return t.notice.calendar.hoursAgo(n: diff.inHours);
    }
    if (diff.inMinutes > 0) {
      return t.notice.calendar.minutesAgo(n: diff.inMinutes);
    }
    return t.notice.calendar.secondsAgo(n: diff.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeAgo,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Palette.grayText,
      ),
    );
  }
}
