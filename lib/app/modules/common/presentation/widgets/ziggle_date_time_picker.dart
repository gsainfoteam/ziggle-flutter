import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/modules/common/presentation/extensions/date_time.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class ZiggleDateTimePicker extends StatefulWidget {
  const ZiggleDateTimePicker({
    super.key,
    this.dateTime,
    required this.onChange,
  });

  final DateTime? dateTime;
  final ValueChanged<DateTime?> onChange;

  @override
  State<ZiggleDateTimePicker> createState() => _ZiggleDateTimePickerState();
}

class _ZiggleDateTimePickerState extends State<ZiggleDateTimePicker> {
  bool _showMonthSelector = false;
  DateTime _currentShowing = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ZigglePressable(
              onPressed: () => setState(() {
                widget.onChange(null);
                _showMonthSelector = !_showMonthSelector;
              }),
              child: Row(
                children: [
                  Text(
                    DateFormat.yM().format(_currentShowing),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Palette.black,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _showMonthSelector ? 0.25 : 0,
                    duration: const Duration(milliseconds: 100),
                    child: Assets.icons.arrowRight.svg(width: 20),
                  ),
                ],
              ),
            ),
            const Spacer(),
            AnimatedOpacity(
              opacity: _showMonthSelector ? 0 : 1,
              duration: const Duration(milliseconds: 100),
              child: AbsorbPointer(
                absorbing: _showMonthSelector,
                child: Row(
                  children: [
                    ZigglePressable(
                      onPressed: () => setState(
                        () {
                          widget.onChange(null);
                          _currentShowing = DateTime(
                            _currentShowing.year,
                            _currentShowing.month - 1,
                          );
                        },
                      ),
                      child: Assets.icons.arrowLeft.svg(width: 30),
                    ),
                    const SizedBox(width: 10),
                    ZigglePressable(
                      onPressed: () => setState(
                        () {
                          widget.onChange(null);
                          _currentShowing = DateTime(
                            _currentShowing.year,
                            _currentShowing.month + 1,
                          );
                        },
                      ),
                      child: Assets.icons.arrowRight.svg(width: 30),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 100),
          crossFadeState: _showMonthSelector
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: _buildCalendar(),
          secondChild: SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.monthYear,
              onDateTimeChanged: (v) => setState(() => _currentShowing = v),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildCalendar() {
    final firstDateOfMonth = DateTime(
      _currentShowing.year,
      _currentShowing.month,
      1,
    );
    final firstDateOfWeek = firstDateOfMonth.subtract(
      Duration(days: firstDateOfMonth.weekday % 7),
    );
    final lastDateOfMonth = DateTime(
      _currentShowing.year,
      _currentShowing.month + 1,
      0,
    );
    final weeks = List.generate(
      lastDateOfMonth.difference(firstDateOfWeek).inDays ~/ 7 + 1,
      (index) => List.generate(
        7,
        (index2) => firstDateOfWeek.add(
          Duration(days: index * 7 + index2),
        ),
      ),
    );
    return Column(
      children: [
        Row(
          children: List.generate(
            7,
            (index) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  DateFormat().dateSymbols.SHORTWEEKDAYS[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Palette.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        ...weeks.map(
          (week) => AnimatedSize(
            duration: const Duration(milliseconds: 100),
            child: SizedBox(
              height: widget.dateTime == null ||
                      week.any(widget.dateTime!.isSameDate)
                  ? null
                  : 0,
              child: Row(
                children: week
                    .map(
                      (day) => Expanded(
                        child: ZigglePressable(
                          onPressed: () => widget.onChange(day),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              DateFormat.d().format(day),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: widget.dateTime?.isSameDate(day) ?? false
                                    ? Palette.primary
                                    : firstDateOfMonth.month == day.month
                                        ? Palette.black
                                        : Palette.gray,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(height: 0),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Text(
                context.t.notice.write.deadline.timeSelect,
                style: const TextStyle(
                  fontSize: 18,
                  color: Palette.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              if (widget.dateTime != null)
                SizedBox(
                  height: 150,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: widget.dateTime,
                    onDateTimeChanged: (v) => widget.onChange(v),
                  ),
                )
            ],
          ),
          crossFadeState: widget.dateTime == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 100),
        ),
      ],
    );
  }
}
