import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_app_bar.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_bottom_sheet.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_date_time_picker.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/modules/notice/domain/enums/notice_type.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class NoticeWriteConfigPage extends StatefulWidget {
  const NoticeWriteConfigPage({super.key});

  @override
  State<NoticeWriteConfigPage> createState() => _NoticeWriteConfigPageState();
}

class _NoticeWriteConfigPageState extends State<NoticeWriteConfigPage> {
  NoticeType? _type;
  DateTime? _deadline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZiggleAppBar.compact(
        backLabel: t.common.cancel,
        title: Text(t.notice.write.configTitle),
        actions: [
          ZiggleButton.text(
            disabled: _type == null,
            onPressed: _type == null ? null : () {},
            child: Text(
              t.common.done,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            children: [
              _buildChangeAccount(),
              const SizedBox(height: 25),
              _buildDeadline(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangeAccount() {
    return ZigglePressable(
      onPressed: () {},
      decoration: const BoxDecoration(
        color: Palette.grayLight,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Assets.images.defaultProfile.image(width: 40),
            const SizedBox(width: 10),
            const Text(
              '홍길동',
              style: TextStyle(
                color: Palette.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              t.notice.write.changeAccount,
              style: const TextStyle(
                color: Palette.grayText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            Assets.icons.navArrowRight.svg(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadline() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Palette.grayLight,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.icons.clock.svg(),
              const SizedBox(width: 6),
              Text.rich(
                t.notice.write.deadline.label(
                  small: (text) => TextSpan(
                    text: text,
                    style: const TextStyle(
                      color: Palette.gray,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Palette.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Switch(
                value: _deadline != null,
                onChanged: (v) async {
                  if (_deadline != null) {
                    setState(() => _deadline = null);
                    return;
                  }
                  final dateTime = await ZiggleBottomSheet.show<DateTime>(
                    context: context,
                    title: t.notice.write.deadline.title,
                    builder: (context) => _DeadlineSelector(
                      onChanged: (v) => Navigator.pop(context, v),
                    ),
                  );
                  if (dateTime == null || !mounted) return;
                  setState(() => _deadline = dateTime);
                },
              ),
            ],
          ),
          if (_deadline != null) ...[
            const SizedBox(height: 10),
            ZigglePressable(
              onPressed: () async {
                final dateTime = await ZiggleBottomSheet.show<DateTime>(
                  context: context,
                  title: t.notice.write.deadline.title,
                  builder: (context) => _DeadlineSelector(
                    initialDateTime: _deadline,
                    onChanged: (v) => Navigator.pop(context, v),
                  ),
                );
                if (dateTime == null || !mounted) return;
                setState(() => _deadline = dateTime);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Palette.grayBorder),
                ),
                child: Center(
                  child: Text(
                    DateFormat.yMd().add_jm().format(_deadline!),
                    style: const TextStyle(
                      color: Palette.grayText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DeadlineSelector extends StatefulWidget {
  const _DeadlineSelector({required this.onChanged, this.initialDateTime});

  final ValueChanged<DateTime?> onChanged;
  final DateTime? initialDateTime;

  @override
  State<_DeadlineSelector> createState() => __DeadlineSelectorState();
}

class __DeadlineSelectorState extends State<_DeadlineSelector> {
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
                onPressed: () => widget.onChanged(null),
                outlined: true,
                child: Text(t.common.cancel),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ZiggleButton.cta(
                onPressed: _dateTime == null
                    ? null
                    : () => widget.onChanged(_dateTime),
                disabled: _dateTime == null,
                child: Text(t.notice.write.deadline.confirm),
              ),
            ),
          ],
        )
      ],
    );
  }
}
