import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        Text(
          t.notice.additional,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        if (previousDeadline != deadline)
          Row(
            children: [
              Text.rich(
                t.notice.deadlineChanged(
                  previous: TextSpan(
                    text: DateFormat.yMd()
                        .add_Hm()
                        .format(previousDeadline!.toLocal()),
                  ),
                  current: TextSpan(
                    text: DateFormat.yMd().add_Hm().format(deadline!.toLocal()),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(width: 4),
            ],
          ),
        Text(body),
      ],
    );
  }
}
