import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/palette.dart';

class ZiggleButton extends StatefulWidget {
  final Widget? child;
  final void Function()? onTap;
  final BoxDecoration decoration;
  final String? text;
  final Color textColor;
  final double fontSize;
  final Color color;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final bool loading;
  const ZiggleButton({
    super.key,
    this.child,
    this.onTap,
    BoxDecoration? decoration,
    this.text,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.color = Palette.primaryColor,
    this.textStyle,
    this.padding,
    this.loading = false,
  })  : assert(child == null || text == null,
            'Cannot provide both child and text'),
        decoration = decoration ??
            const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            );

  @override
  State<ZiggleButton> createState() => _ZiggleButtonState();
}

class _ZiggleButtonState extends State<ZiggleButton> {
  bool get _isTransparent => widget.color == Colors.transparent;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.loading ? null : widget.onTap,
      onTapDown: (_) => setState(() => _hover = true),
      onTapCancel: () => setState(() => _hover = false),
      onTapUp: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: 100.milliseconds,
        padding: widget.padding ??
            EdgeInsets.symmetric(
              horizontal: 20,
              vertical: _isTransparent ? 0 : 10,
            ),
        decoration: widget.decoration.copyWith(
          color: Color.lerp(
            widget.color,
            Palette.black,
            widget.loading
                ? 0.4
                : _hover && widget.onTap != null
                    ? 0.1
                    : 0,
          ),
        ),
        child: _buildChild(),
      ),
    );
  }

  _buildChild() {
    if (widget.text == null) {
      return widget.child ?? const SizedBox.shrink();
    }
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Text(
          widget.text!,
          style: widget.textStyle ??
              TextStyle(
                fontSize: widget.fontSize,
                color: _isTransparent ? Palette.black : widget.textColor,
                fontWeight:
                    _isTransparent ? FontWeight.normal : FontWeight.bold,
              ),
        ),
        if (widget.loading)
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
