import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class DDay extends StatefulWidget {
  const DDay({super.key, required this.deadline});

  final DateTime deadline;

  @override
  State<DDay> createState() => _DDayState();
}

class _DDayState extends State<DDay> {
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

  (
    int?,
    TextSpan Function(
        {required num n, required InlineSpan Function(num p1) nBuilder})?
  ) _getN() {
    final now = DateTime.now();
    final diff = widget.deadline.difference(now);
    if (diff.isNegative) {
      return (null, null);
    }
    final daysLeft = diff.inDays;
    if (daysLeft > 0) {
      return (daysLeft, t.notice.dDay.daysLeft);
    }
    final hoursLeft = diff.inHours;
    if (hoursLeft > 0) {
      return (hoursLeft, t.notice.dDay.hoursLeft);
    }
    final minutesLeft = diff.inMinutes;
    if (minutesLeft > 0) {
      return (minutesLeft, t.notice.dDay.minutesLeft);
    }
    final secondsLeft = diff.inSeconds;
    return (secondsLeft, t.notice.dDay.secondsLeft);
  }

  @override
  Widget build(BuildContext context) {
    final (n, builder) = _getN();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: n != null ? Palette.primary : Palette.grayText,
      ),
      child: n != null
          ? Text.rich(
              builder!(
                n: n,
                nBuilder: (n) => TextSpan(
                  text: n.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Palette.white,
              ),
            )
          : Text(
              t.notice.dDay.overdue,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Palette.white,
              ),
            ),
    );
  }
}
