import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/colors.dart';

class ZiggleButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onTap;
  final BorderRadius borderRadius;
  final String? text;
  final Color textColor;
  final double fontSize;
  final Color color;
  bool get _isTransparent => color == Colors.transparent;

  const ZiggleButton({
    super.key,
    this.child,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.text,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.color = Palette.primaryColor,
  }) : assert(child == null || text == null,
            'Cannot provide both child and text');

  @override
  Widget build(BuildContext context) {
    final hover = false.obs;
    return GestureDetector(
      onTap: onTap,
      onTapDown: (_) => hover.value = true,
      onTapCancel: () => hover.value = false,
      onTapUp: (_) => hover.value = false,
      child: Obx(
        () => AnimatedContainer(
          height: _isTransparent ? null : 40,
          duration: 100.milliseconds,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Color.lerp(
              color,
              Palette.black,
              hover.value && onTap != null ? 0.1 : 0,
            ),
            borderRadius: borderRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildChild()],
          ),
        ),
      ),
    );
  }

  _buildChild() {
    if (text == null) {
      return child ?? const SizedBox.shrink();
    }
    return Text(
      text!,
      style: TextStyle(
        fontSize: fontSize,
        color: _isTransparent ? Palette.black : textColor,
        fontWeight: _isTransparent ? FontWeight.normal : FontWeight.bold,
      ),
    );
  }
}
