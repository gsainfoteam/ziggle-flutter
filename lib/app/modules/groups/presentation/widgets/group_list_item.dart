import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class GroupListItem extends StatelessWidget {
  const GroupListItem({
    super.key,
    required this.name,
    this.isCertificated = false,
    this.isGrouped = true,
  });

  final String name;
  final bool isCertificated;
  final bool isGrouped;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isGrouped ? const EdgeInsets.all(10) : null,
      decoration: isGrouped
          ? ShapeDecoration(
              color: Palette.grayLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            )
          : null,
      child: Row(
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
          const SizedBox(width: 10),
          const Text(
            '그룹 이름',
            style: TextStyle(),
          ),
          const SizedBox(width: 5),
          if (isCertificated == true) Assets.icons.certificatedBadge.svg(),
        ],
      ),
    );
  }
}
