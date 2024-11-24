import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class ZiggleRowButton extends StatelessWidget {
  const ZiggleRowButton({
    super.key,
    this.icon,
    required this.title,
    this.disabled = false,
    this.showChevron = true,
    this.destructive = false,
    this.isLocked = false,
    this.onPressed,
  });

  final Widget? icon;
  final Widget title;
  final bool disabled;
  final bool destructive;
  final bool isLocked;
  final bool showChevron;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ZigglePressable(
      onPressed: disabled ? null : onPressed,
      decoration: const BoxDecoration(
        color: Palette.grayLight,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            if (icon != null) icon!,
            const SizedBox(width: 5),
            Expanded(
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: disabled
                      ? Palette.gray
                      : destructive
                          ? Palette.primary
                          : Palette.black,
                ),
                child: Row(
                  children: [
                    title,
                    if (isLocked) ...[
                      SizedBox(width: 5),
                      Assets.icons.lock.svg(),
                    ]
                  ],
                ),
              ),
            ),
            if (showChevron) Assets.icons.chevronRight.svg(),
          ],
        ),
      ),
    );
  }
}
