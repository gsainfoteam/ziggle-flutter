import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class GroupListItem extends StatelessWidget {
  const GroupListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: ShapeDecoration(
            color: Palette.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        const Text('그룹 이름', style: TextStyle(),)
      ],
    );
  }
}
