import 'package:flutter/material.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class DDay extends StatelessWidget {
  final DateTime date;
  const DDay({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final label = _ddayFormatted(date);
    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(
        color: Palette.primary100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(label, style: TextStyles.ddayStyle),
    );
  }
}

String _ddayFormatted(DateTime date) {
  final diff = date.difference(DateTime.now());
  final milli = diff.inMilliseconds;
  final days = milli / (1000 * 60 * 60 * 24);
  if (days < 0) return t.article.deadlineOverdue;
  if (days < 1) return 'D - Day';
  return 'D - ${days.toInt()}';
}
