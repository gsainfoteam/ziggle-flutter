import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/core/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

import '../../domain/enums/notice_type.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  DateTime? _deadline;
  NoticeType? _type;
  bool get _done => _type != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Theme.of(context).appBarTheme.toolbarHeight,
        title: Text(t.notice.write.title),
        actions: [
          ZiggleButton(
            onTap: _done ? () {} : null,
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              t.notice.write.action,
              style: TextStyle(
                color: _done ? Palette.primary100 : Palette.textGrey,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextFormField(
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  hintText: t.notice.write.titleHint,
                  hintStyle: const TextStyle(color: Palette.textGrey),
                ),
              ),
            ),
            const Divider(indent: 18, endIndent: 18, height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        t.notice.write.deadline,
                        style: TextStyle(
                          fontSize: 16,
                          color: _deadline == null
                              ? Palette.textGrey
                              : Palette.primary100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                        value: _deadline != null,
                        onChanged: (_) => setState(
                          () => _deadline =
                              _deadline == null ? DateTime.now() : null,
                        ),
                        activeColor: Palette.primary100,
                      ),
                    ],
                  ),
                  if (_deadline != null)
                    SizedBox(
                      height: 150,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        initialDateTime: _deadline,
                        onDateTimeChanged: (v) => setState(() => _deadline = v),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(indent: 18, endIndent: 18, height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Assets.icons.list.svg(),
                  const SizedBox(width: 6),
                  Text(
                    t.notice.write.type,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final type = NoticeType.writable[index];
                  final selected = _type == type;
                  return ZiggleButton(
                    color: selected
                        ? Palette.primary100
                        : Palette.backgroundGreyLight,
                    onTap: () => setState(() => _type = type),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(children: [
                      type.icon.svg(
                        colorFilter: selected
                            ? const ColorFilter.mode(
                                Palette.white,
                                BlendMode.srcIn,
                              )
                            : null,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        type.name,
                        style: TextStyle(
                          color: selected ? Palette.white : Palette.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ]),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: NoticeType.writable.length,
              ),
            ),
            const Divider(indent: 18, endIndent: 18, height: 40),
          ],
        ),
      ),
    );
  }
}
