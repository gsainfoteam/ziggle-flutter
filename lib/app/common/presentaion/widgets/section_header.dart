import 'package:flutter/material.dart';
import 'package:ziggle/app/core/themes/text.dart';
import 'package:ziggle/app/data/enums/article_type.dart';
import 'package:ziggle/gen/assets.gen.dart';

class SectionHeader extends StatelessWidget {
  final ArticleType type;
  final void Function() onTap;
  const SectionHeader({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type.header, style: TextStyles.articleTitleStyle),
          Assets.icons.rightArrow.image(width: 18, height: 18),
        ],
      ),
    );
  }
}
