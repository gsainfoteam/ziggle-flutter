import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class ZiggleRowButton extends StatelessWidget {
  const ZiggleRowButton({
    super.key,
    this.leadingIcon,
    required this.title,
    this.disabled = false,
    this.showChevron = true,
    this.destructive = false,
    this.trailingIcon,
    this.onPressed,
  });

  final Widget? leadingIcon;
  final Widget title;
  final bool disabled;
  final bool destructive;
  final Widget? trailingIcon;
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
            if (leadingIcon != null) leadingIcon!,
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
                    if (trailingIcon != null) ...[
                      SizedBox(width: 5),
                      trailingIcon!,
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
