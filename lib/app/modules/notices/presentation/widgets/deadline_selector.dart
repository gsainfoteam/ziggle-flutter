import 'package:flutter/material.dart';
import 'package:ziggle/app/di/locator.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_date_time_picker.dart';
import 'package:ziggle/app/modules/core/data/models/analytics_event.dart';
import 'package:ziggle/app/modules/core/domain/enums/event_type.dart';
import 'package:ziggle/app/modules/core/domain/repositories/analytics_repository.dart';
import 'package:ziggle/gen/strings.g.dart';

class DeadlineSelector extends StatefulWidget {
  const DeadlineSelector({
    super.key,
    required this.onChanged,
    this.initialDateTime,
    required this.isEditMode,
  });

  final ValueChanged<DateTime?> onChanged;
  final DateTime? initialDateTime;
  final bool isEditMode;

  @override
  State<DeadlineSelector> createState() => _DeadlineSelectorState();
}

class _DeadlineSelectorState extends State<DeadlineSelector> {
  late DateTime? _dateTime = widget.initialDateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ZiggleDateTimePicker(
            dateTime: _dateTime,
            onChange: (v) => setState(() => _dateTime = v),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ZiggleButton.cta(
                onPressed: () {
                  widget.isEditMode
                      ? AnalyticsRepository.click(
                          const AnalyticsEvent.noticeEditSetDeadlineCancel())
                      : AnalyticsRepository.click(
                          const AnalyticsEvent.writeConfigSetDeadlineCancel());
                  widget.onChanged(null);
                },
                outlined: true,
                child: Text(context.t.common.cancel),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ZiggleButton.cta(
                onPressed: _dateTime == null
                    ? null
                    : () {
                        widget.isEditMode
                            ? AnalyticsRepository.click(
                                const AnalyticsEvent.noticeEditSetDeadline())
                            : AnalyticsRepository.click(
                                const AnalyticsEvent.writeConfigSetDeadline());

                        widget.onChanged(_dateTime);
                      },
                disabled: _dateTime == null,
                child: Text(context.t.notice.write.deadline.confirm),
              ),
            ),
          ],
        )
      ],
    );
  }
}
