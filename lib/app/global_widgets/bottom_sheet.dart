import 'package:flutter/material.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/core/values/shadows.dart';

class ZiggleBottomSheet extends StatelessWidget {
  final Widget? child;
  final ScrollController? scrollController;

  const ZiggleBottomSheet({
    super.key,
    this.child,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 68,
          height: 5,
          decoration: const BoxDecoration(
            color: Palette.placeholder,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        if (child != null) child!,
      ],
    );
    return Container(
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: frameShadows,
      ),
      child:
          SingleChildScrollView(controller: scrollController, child: content),
    );
  }
}
