import 'package:flutter/material.dart';

class ZigglePressable extends StatefulWidget {
  const ZigglePressable({
    super.key,
    required this.onPressed,
    required this.child,
    this.decoration = const BoxDecoration(),
  });

  final VoidCallback? onPressed;
  final Widget child;
  final BoxDecoration decoration;

  @override
  State<ZigglePressable> createState() => _ZigglePressableState();
}

class _ZigglePressableState extends State<ZigglePressable> {
  bool _pressed = false;
  bool _active = false;
  bool get pressed => _pressed || _active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed == null) return;
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
      onTap: widget.onPressed,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: widget.onPressed != null && pressed ? 0.95 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: widget.decoration.copyWith(
            color: widget.decoration.color?.withOpacity(
              widget.onPressed != null && pressed ? 0.8 : 1,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
