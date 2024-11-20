import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class GroupListItem extends StatelessWidget {
  const GroupListItem({
    super.key,
    required this.name,
    this.isCertificated = false,
    this.isGrouped = true,
    this.profileImage,
    this.onPressed,
  });

  final String name;
  final Image? profileImage;
  final bool isCertificated;
  final bool isGrouped;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ZigglePressable(
      onPressed: onPressed,
      child: Container(
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
            if (profileImage != null)
              SizedBox(
                height: 36,
                width: 36,
                child: profileImage,
              )
            else
              SizedBox(
                height: 36,
                width: 36,
                child: Assets.images.groupDefaultProfile.image(),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isCertificated) ...[
              const SizedBox(width: 5),
              Assets.icons.certificatedBadge.svg(),
            ]
          ],
        ),
      ),
    );
  }
}
