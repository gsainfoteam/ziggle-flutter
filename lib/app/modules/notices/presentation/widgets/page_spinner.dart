import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/core/values/palette.dart';
import 'package:ziggle/app/core/values/shadows.dart';
import 'package:ziggle/gen/assets.gen.dart';

class PageSpinner extends StatelessWidget {
  final int currentPage;
  final int maxPage;
  final void Function(int)? onPageChanged;
  final bool isLight;

  const PageSpinner({
    super.key,
    required this.currentPage,
    required this.maxPage,
    this.onPageChanged,
    this.isLight = true,
  });

  @override
  Widget build(BuildContext context) {
    final image = isLight
        ? Assets.icons.rightArrow.image(width: 20)
        : Assets.icons.rightArrowWhite.image(width: 20);
    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isLight ? Palette.white : Palette.black,
        borderRadius: BorderRadius.circular(100),
        boxShadow: isLight ? frameShadows : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => onPageChanged?.call(max(1, currentPage - 1)),
            child: RotatedBox(quarterTurns: 2, child: image),
          ),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: isLight ? null : Palette.white,
              ),
              children: [
                TextSpan(
                  text: '$currentPage ',
                  style: TextStyles.titleTextStyle,
                ),
                TextSpan(
                  text: '/ $maxPage',
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: () => onPageChanged?.call(min(maxPage, currentPage + 1)),
            child: image,
          ),
        ],
      ),
    );
  }
}
