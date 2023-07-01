import 'package:flutter/material.dart';
import 'package:ziggle/app/core/values/colors.dart';

class ZiggleButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onTap;
  final BorderRadius borderRadius;
  final String? text;
  final Color textColor;
  final double fontSize;
  final Color color;

  const ZiggleButton({
    super.key,
    this.child,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.text,
    this.textColor = Palette.white,
    this.fontSize = 16,
    this.color = Palette.primaryColor,
  }) : assert(child == null || text == null,
            'Cannot provide both child and text');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(color: color, borderRadius: borderRadius),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildChild()],
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
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
