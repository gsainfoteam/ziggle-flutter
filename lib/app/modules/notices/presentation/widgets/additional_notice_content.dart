import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class AdditionalNoticeContent extends StatelessWidget {
  const AdditionalNoticeContent({
    super.key,
    required this.body,
    this.previousDeadline,
    this.deadline,
    required this.createdAt,
  });

  final String body;
  final DateTime? previousDeadline;
  final DateTime? deadline;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              t.notice.additional,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Palette.textGreyDark,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(child: Divider()),
          ],
        ),
        if (previousDeadline != deadline)
          DefaultTextStyle.merge(
            style: const TextStyle(color: Palette.primary100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.notice.deadlineChanged),
                Row(
                  children: [
                    Text(DateFormat.yMd()
                        .add_Hm()
                        .format(previousDeadline!.toLocal())),
                    const Text(' ▶ ️'),
                    Text(
                      DateFormat.yMd()
                          .add_Hm()
                          .format(previousDeadline!.toLocal()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        Text(body),
        const SizedBox(height: 20),
      ],
    );
  }
}
