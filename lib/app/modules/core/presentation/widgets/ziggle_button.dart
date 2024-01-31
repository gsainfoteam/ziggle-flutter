import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

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
    this.color = Palette.primary100,
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
  bool _small = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.loading ? null : widget.onTap,
      onTapDown: (_) => setState(() {
        _hover = true;
        _small = true;
      }),
      onTapCancel: () => setState(() => _hover = false),
      onTapUp: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: (_hover || _small) && widget.onTap != null ? 0.95 : 1,
        onEnd: () => setState(() => _small = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
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
      ),
    );
  }

  _buildChild() {
    final textStyle = widget.textStyle ??
        TextStyle(
          fontSize: widget.fontSize,
          color: _isTransparent ? Palette.black : widget.textColor,
          fontWeight: _isTransparent ? FontWeight.normal : FontWeight.bold,
        );
    if (widget.text == null) {
      return Theme(
        data: Theme.of(context).copyWith(
          iconTheme: Theme.of(context).iconTheme.copyWith(
                color: widget.textColor,
              ),
        ),
        child: DefaultTextStyle(
          style: textStyle,
          child: widget.child ?? const SizedBox.shrink(),
        ),
      );
    }
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Text(widget.text!, style: textStyle),
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
