import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

enum ZiggleButtonType {
  cta(EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
  big(EdgeInsets.symmetric(vertical: 10, horizontal: 25)),
  small(EdgeInsets.symmetric(vertical: 7, horizontal: 15)),
  text(EdgeInsets.zero);

  final EdgeInsets padding;
  const ZiggleButtonType(this.padding);
}

class ZiggleButton extends StatefulWidget {
  const ZiggleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.outlined = false,
    this.loading = false,
    this.disabled = false,
    this.emphasize = true,
    this.type = ZiggleButtonType.cta,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool loading;
  final bool disabled;
  final bool emphasize;
  final ZiggleButtonType type;

  @override
  State<ZiggleButton> createState() => _ZiggleButtonState();
}

class _ZiggleButtonState extends State<ZiggleButton> {
  bool _pressed = false;
  bool _active = false;
  bool get pressed => _pressed || _active;

  Color get _effectiveColor {
    if (widget.type == ZiggleButtonType.text) return Palette.primary;
    if (widget.disabled) return Palette.gray;
    if (widget.outlined) return Palette.primary;
    if (widget.emphasize) return Palette.white;
    return Palette.black;
  }

  Color? get _effectiveBackgroundColor {
    if (widget.type == ZiggleButtonType.text) return null;
    if (widget.disabled) return Palette.grayLight;
    if (widget.outlined) return null;
    if (widget.emphasize) return Palette.primary;
    return Palette.grayLight;
  }

  Color? get _effectiveBorderColor {
    if (widget.type == ZiggleButtonType.text) return null;
    if (widget.disabled) return null;
    if (widget.outlined) return Palette.primary;
    if (widget.emphasize) return null;
    return Palette.grayBorder;
  }

  @override
  Widget build(BuildContext context) {
    Widget inner = DefaultTextStyle.merge(
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ).copyWith(color: _effectiveColor),
      child: widget.child,
    );

    return GestureDetector(
      onTapDown: (_) {
        if (widget.disabled) return;
        setState(() {
          _pressed = true;
          _active = true;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!mounted) return;
          setState(() => _active = false);
        });
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.loading ? null : widget.onPressed,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: widget.onPressed != null && pressed ? 0.95 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: widget.type.padding,
          width: widget.type == ZiggleButtonType.cta ? double.infinity : null,
          decoration: BoxDecoration(
            color: _effectiveBackgroundColor
                ?.withOpacity(widget.onPressed != null && pressed ? 0.8 : 1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: _effectiveBorderColor ?? Colors.transparent,
              style: _effectiveBorderColor == null
                  ? BorderStyle.none
                  : BorderStyle.solid,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(opacity: widget.loading ? 0 : 1, child: inner),
              Opacity(
                opacity: widget.loading ? 1 : 0,
                child: const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
