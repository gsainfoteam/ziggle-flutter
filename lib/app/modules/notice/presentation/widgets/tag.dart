import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

class Tag extends StatelessWidget {
  const Tag({
    super.key,
    this.onDelete = false,
    this.onPressed,
    this.loading = false,
    this.tag = '#태그1',
  });

  final bool onDelete;
  final VoidCallback? onPressed;
  final bool loading;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: onDelete ? Palette.primaryMedium : Palette.primaryLight,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
                color: Palette.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (onDelete)
            const SizedBox(
              width: 10,
            ),
          if (onDelete)
            ZigglePressable(
              onPressed: loading ? null : onPressed,
              child: Assets.icons.xmarkCircle.svg(
                width: 24.0,
                height: 24.0,
              ),
            ),
        ],
      ),
    );
  }
}
