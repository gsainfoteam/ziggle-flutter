import 'package:flutter/material.dart';
import 'package:ziggle/gen/assets.gen.dart';

class ZiggleLogo extends StatelessWidget {
  const ZiggleLogo({super.key, this.long = false});

  final bool long;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Assets.logo.fire.svg(width: 32, height: 32),
        const SizedBox(width: 4),
        if (long) Assets.logo.long.svg() else Assets.logo.short.svg()
      ],
    );
  }
}
