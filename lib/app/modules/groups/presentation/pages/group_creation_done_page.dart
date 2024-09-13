import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_select.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupCreationDonePage extends StatefulWidget {
  const GroupCreationDonePage({super.key});

  @override
  State<GroupCreationDonePage> createState() => _GroupCreationDonePageState();
}

class _GroupCreationDonePageState extends State<GroupCreationDonePage> {
  int? _duration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.icons.doneCheck.svg(width: 100),
        const SizedBox(height: 20),
        Text(
          t.group.creation.done.title(name: "인포팀"),
          style: const TextStyle(
            fontSize: 24,
            color: Palette.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          t.group.creation.done.description,
          style: const TextStyle(
            fontSize: 18,
            color: Palette.grayText,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Container(
          decoration: const BoxDecoration(
            color: Palette.grayLight,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Assets.icons.link.svg(width: 24),
                  const SizedBox(width: 6),
                  Text(
                    t.group.creation.done.invite.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Palette.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ZiggleSelect(
                onChanged: (v) => setState(() => _duration = v),
                hintText: t.group.creation.done.invite.selectExpire,
                entries: [
                  ZiggleSelectEntry(
                    value: 1,
                    label: t.common.duration.day(n: 1),
                  ),
                  ZiggleSelectEntry(
                    value: 3,
                    label: t.common.duration.day(n: 3),
                  ),
                  ZiggleSelectEntry(
                    value: 7,
                    label: t.common.duration.week(n: 1),
                  ),
                ],
              ),
              if (_duration != null) ...[
                const SizedBox(height: 10),
                ZiggleButton.cta(
                  emphasize: false,
                  child: Text(t.group.creation.done.invite.copy),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 30),
        ZiggleButton.cta(
          onPressed: () => context.pop(),
          child: Text(t.group.creation.done.back),
        )
      ],
    );
  }
}
