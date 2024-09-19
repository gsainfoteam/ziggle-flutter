import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class EditDeadline extends StatefulWidget {
  const EditDeadline({
    super.key,
    required this.deadline,
    this.alreadyPassed = false,
  });

  final DateTime deadline;
  final bool alreadyPassed;

  @override
  State<EditDeadline> createState() => _EditDeadlineState();
}

class _EditDeadlineState extends State<EditDeadline> {
  late Duration duration = widget.deadline.difference(DateTime.now());
  late final Timer timer;
  bool get isPassed => duration.isNegative || widget.alreadyPassed;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          duration = widget.deadline.difference(DateTime.now());
        });
        if (isPassed) {
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isPassed ? const Color(0xFFF5F5F7) : Palette.primaryLight,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: isPassed
            ? Text(
                context.t.notice.edit.cannotEdit,
                style: const TextStyle(
                  color: Palette.grayText,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              )
            : Text.rich(
                context.t.notice.edit.leftTime(
                  bold: TextSpan(
                    text:
                        '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                style: const TextStyle(
                  color: Palette.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
      ),
    );
  }
}
