import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/shadows.dart';
import 'package:ziggle/gen/assets.gen.dart';

class PageSpinner extends StatelessWidget {
  final int currentPage;
  final int maxPage;
  final void Function(int)? onPageChanged;
  const PageSpinner({
    super.key,
    required this.currentPage,
    required this.maxPage,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: frameShadows,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => onPageChanged?.call(max(1, currentPage - 1)),
            child: RotatedBox(
              quarterTurns: 2,
              child: Assets.icons.rightArrow.image(width: 20),
            ),
          ),
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 16),
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
            child: Assets.icons.rightArrow.image(width: 20),
          ),
        ],
      ),
    );
  }
}
