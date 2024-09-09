import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/app/router/routes.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupCreationNotionPage extends StatelessWidget {
  const GroupCreationNotionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.images.notion.image(width: 30),
            const SizedBox(width: 10),
            Text(
              t.group.creation.notion.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Palette.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text.rich(
          t.group.creation.notion.description(
            strong: (text) => TextSpan(
              text: text,
              style: const TextStyle(color: Palette.primary),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Palette.grayText,
          ),
        ),
        const SizedBox(height: 30),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: ZiggleButton(child: Text(t.common.back)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ZiggleButton(
                onPressed: () {
                  context.popUntilPath(const GroupCreationRoute().location);
                  const GroupCreationRoute(GroupCreationStep.done)
                      .pushReplacement(context);
                },
                child: Text(t.common.next),
              ),
            ),
          ],
        )
      ],
    );
  }
}
