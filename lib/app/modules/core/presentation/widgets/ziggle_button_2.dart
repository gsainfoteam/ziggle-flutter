import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleButton2 extends StatefulWidget {
  const ZiggleButton2({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.outlined = false,
    this.chip = false,
    this.loading = false,
    this.disabled = false,
    this.cta = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final bool outlined;
  final bool chip;
  final bool loading;
  final bool disabled;
  final bool cta;

  @override
  State<ZiggleButton2> createState() => _ZiggleButton2State();
}

class _ZiggleButton2State extends State<ZiggleButton2> {
  bool _pressed = false;
  bool _active = false;
  bool get pressed => _pressed || _active;

  Color get _effectiveColor {
    if (widget.color != null) return widget.color!;
    if (widget.disabled) return Palette.text400;
    if (widget.outlined) return Palette.primary100;
    if (widget.cta) return Palette.white;
    return Palette.black;
  }

  Color? get _effectiveBackgroundColor {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    if (widget.disabled) return Palette.background200;
    if (widget.outlined) return null;
    if (widget.cta) return Palette.primary100;
    return Palette.background200;
  }

  Color? get _effectiveBorderColor {
    if (widget.disabled) return null;
    if (widget.outlined) return Palette.primary100;
    if (widget.cta) return null;
    return Palette.borderGreyLight;
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

    if (!widget.chip) {
      inner = ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 20),
        child: inner,
      );
    }
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
          padding: widget.chip
              ? const EdgeInsets.symmetric(vertical: 6, horizontal: 12)
              : const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
