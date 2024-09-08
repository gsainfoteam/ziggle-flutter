import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_button.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class GroupCreationProfilePage extends StatelessWidget {
  const GroupCreationProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Assets.images.groupDefaultProfile.image(width: 300),
        const SizedBox(height: 27),
        IntrinsicWidth(
          child: ZiggleButton(
            emphasize: false,
            child: Text(t.group.creation.setProfileImage),
          ),
        ),
        const SizedBox(height: 60),
        const SizedBox(height: 60),
        ZiggleButton(
          disabled: true,
          child: Text(t.common.next),
        ),
      ],
    );
  }
}
