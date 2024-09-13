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
  const ZiggleButton._({
    super.key,
    required this.child,
    this.onPressed,
    this.outlined = false,
    this.loading = false,
    this.disabled = false,
    this.emphasize = true,
    required this.type,
  });

  factory ZiggleButton.cta({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool outlined = false,
    bool loading = false,
    bool disabled = false,
    bool emphasize = true,
  }) =>
      ZiggleButton._(
        key: key,
        onPressed: onPressed,
        outlined: outlined,
        loading: loading,
        disabled: disabled,
        emphasize: emphasize,
        type: ZiggleButtonType.cta,
        child: child,
      );

  factory ZiggleButton.big({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool outlined = false,
    bool loading = false,
    bool disabled = false,
    bool emphasize = true,
  }) =>
      ZiggleButton._(
        key: key,
        onPressed: onPressed,
        outlined: outlined,
        loading: loading,
        disabled: disabled,
        emphasize: emphasize,
        type: ZiggleButtonType.big,
        child: child,
      );

  factory ZiggleButton.small({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool outlined = false,
    bool loading = false,
    bool disabled = false,
    bool emphasize = true,
  }) =>
      ZiggleButton._(
        key: key,
        onPressed: onPressed,
        outlined: outlined,
        loading: loading,
        disabled: disabled,
        emphasize: emphasize,
        type: ZiggleButtonType.small,
        child: child,
      );

  factory ZiggleButton.text({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    bool loading = false,
    bool disabled = false,
  }) =>
      ZiggleButton._(
        key: key,
        onPressed: onPressed,
        loading: loading,
        disabled: disabled,
        type: ZiggleButtonType.text,
        child: child,
      );

  final Widget child;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool loading;
  final bool disabled;
  final bool emphasize;
  final ZiggleButtonType type;

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
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1,
      ).copyWith(color: _effectiveColor),
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
        padding: type.padding,
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
