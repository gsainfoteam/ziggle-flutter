import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class PromotionButton extends StatelessWidget {
  const PromotionButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.icon,
  });

  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return ZigglePressable(
      onPressed: onPressed,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Palette.grayBorder,
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Palette.grayText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 10),
              SizedBox(width: 40, height: 40, child: icon!),
            ],
            const SizedBox(width: 2),
            Assets.icons.chevronRight.svg(width: 24, height: 24),
          ],
        ),
      ),
    );
  }
}
