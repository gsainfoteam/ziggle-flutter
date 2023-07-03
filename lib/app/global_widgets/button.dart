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
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final bool loading;
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
    this.textStyle,
    this.padding,
    this.loading = false,
  }) : assert(child == null || text == null,
            'Cannot provide both child and text');

  @override
  Widget build(BuildContext context) {
    final hover = false.obs;
    return GestureDetector(
      onTap: loading ? null : onTap,
      onTapDown: (_) => hover.value = true,
      onTapCancel: () => hover.value = false,
      onTapUp: (_) => hover.value = false,
      child: Obx(
        () => AnimatedContainer(
          duration: 100.milliseconds,
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: 20,
                vertical: _isTransparent ? 0 : 10,
              ),
          decoration: BoxDecoration(
            color: Color.lerp(
              color,
              Palette.black,
              loading
                  ? 0.4
                  : hover.value && onTap != null
                      ? 0.1
                      : 0,
            ),
            borderRadius: borderRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Text(
          text!,
          style: textStyle ??
              TextStyle(
                fontSize: fontSize,
                color: _isTransparent ? Palette.black : textColor,
                fontWeight:
                    _isTransparent ? FontWeight.normal : FontWeight.bold,
              ),
        ),
        if (loading)
          Positioned.fill(
            child: LayoutBuilder(builder: (context, constraints) {
              return Center(
                child: SizedBox.square(
                  dimension: constraints.biggest.shortestSide,
                  child: const CircularProgressIndicator.adaptive(),
                ),
              );
            }),
          ),
      ],
    );
  }
}
