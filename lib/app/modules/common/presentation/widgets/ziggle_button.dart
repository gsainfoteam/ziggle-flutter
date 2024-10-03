import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';

enum ZiggleButtonType {
  cta(EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
  big(EdgeInsets.symmetric(vertical: 10, horizontal: 25)),
  small(EdgeInsets.symmetric(vertical: 7, horizontal: 15)),
  text(EdgeInsets.zero),
  textWithPadding(EdgeInsets.symmetric(horizontal: 12));

  final EdgeInsets padding;
  const ZiggleButtonType(this.padding);
}

class ZiggleButton extends StatelessWidget {
  const ZiggleButton.cta({
    super.key,
    required this.child,
    this.onPressed,
    this.outlined = false,
    this.loading = false,
    this.disabled = false,
    this.emphasize = true,
  })  : type = ZiggleButtonType.cta,
        defaultStyle = const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1,
        );

  const ZiggleButton.big({
    super.key,
    required this.child,
    this.onPressed,
    this.outlined = false,
    this.loading = false,
    this.disabled = false,
    this.emphasize = true,
  })  : type = ZiggleButtonType.big,
        defaultStyle = const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1,
        );

  const ZiggleButton.small({
    super.key,
    required this.child,
    this.onPressed,
    this.outlined = false,
    this.loading = false,
    this.disabled = false,
    this.emphasize = true,
  })  : type = ZiggleButtonType.small,
        defaultStyle = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1,
        );

  const ZiggleButton.text({
    super.key,
    required this.child,
    this.onPressed,
    this.loading = false,
    this.disabled = false,
  })  : type = ZiggleButtonType.text,
        defaultStyle = const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
        outlined = false,
        emphasize = false;

  final Widget child;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool loading;
  final bool disabled;
  final bool emphasize;
  final ZiggleButtonType type;
  final TextStyle defaultStyle;

  Color get _effectiveColor {
    if (disabled) return Palette.gray;
    if (type == ZiggleButtonType.text) return Palette.primary;
    if (type == ZiggleButtonType.textWithPadding) return Palette.primary;
    if (outlined) return Palette.primary;
    if (emphasize) return Palette.white;
    return Palette.black;
  }

  Color? get _effectiveBackgroundColor {
    if (type == ZiggleButtonType.text) return null;
    if (type == ZiggleButtonType.textWithPadding) return null;
    if (disabled) return Palette.grayLight;
    if (outlined) return null;
    if (emphasize) return Palette.primary;
    return Palette.grayLight;
  }

  Color? get _effectiveBorderColor {
    if (type == ZiggleButtonType.text) return null;
    if (type == ZiggleButtonType.textWithPadding) return null;
    if (disabled) return null;
    if (outlined) return Palette.primary;
    if (emphasize) return null;
    return Palette.grayBorder;
  }

  @override
  Widget build(BuildContext context) {
    Widget inner = DefaultTextStyle.merge(
      style: defaultStyle.copyWith(color: _effectiveColor),
      child: child,
    );

    return ZigglePressable(
      onPressed: disabled || loading ? null : onPressed,
      decoration: BoxDecoration(
        color: _effectiveBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: _effectiveBorderColor ?? Colors.transparent,
          style: _effectiveBorderColor == null
              ? BorderStyle.none
              : BorderStyle.solid,
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: type == ZiggleButtonType.cta ? double.infinity : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: type.padding,
              child: Opacity(opacity: loading ? 0 : 1, child: inner),
            ),
            Positioned.fill(
              child: Center(
                child: Opacity(
                  opacity: loading ? 1 : 0,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
