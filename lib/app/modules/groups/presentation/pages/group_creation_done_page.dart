import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupCreationDonePage extends StatelessWidget {
  const GroupCreationDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        const SizedBox(height: 30),
        ZiggleButton(
          // onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          onPressed: () => context.pop(),
          child: Text(t.group.creation.done.back),
        )
      ],
    );
  }
}
