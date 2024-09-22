import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/functions/noop.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

InlineSpan? _dDaySpan(InlineSpan Function(num) nBuilder, DateTime deadline) {
  final now = DateTime.now();
  final diff = deadline.difference(now);
  if (diff.isNegative) return null;
  final daysLeft = diff.inDays;
  if (daysLeft > 0) {
    return t.notice.dDay.daysLeft(n: daysLeft, nBuilder: nBuilder);
  }
  final hoursLeft = diff.inHours;
  if (hoursLeft > 0) {
    return t.notice.dDay.hoursLeft(n: hoursLeft, nBuilder: nBuilder);
  }
  final minutesLeft = diff.inMinutes;
  if (minutesLeft > 0) {
    return t.notice.dDay.minutesLeft(n: minutesLeft, nBuilder: nBuilder);
  }
  final secondsLeft = diff.inSeconds;
  return t.notice.dDay.secondsLeft(n: secondsLeft, nBuilder: nBuilder);
}

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
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(noop));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final span = _dDaySpan(
        (n) => TextSpan(
              text: n.toString(),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
        widget.deadline);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: span != null ? Palette.primary : Palette.grayText,
      ),
      child: span != null
          ? Text.rich(
              span,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Palette.white,
              ),
            )
          : Text(
              context.t.notice.dDay.overdue,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Palette.white,
              ),
            ),
    );
  }
}
