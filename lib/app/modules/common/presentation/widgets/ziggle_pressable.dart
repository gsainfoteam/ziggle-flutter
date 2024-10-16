import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZigglePressable extends StatefulWidget {
  const ZigglePressable({
    super.key,
    required this.onPressed,
    required this.child,
    this.decoration = const BoxDecoration(),
    this.behavior,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final BoxDecoration decoration;
  final HitTestBehavior? behavior;

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
      behavior: widget.behavior,
      onTapDown: (_) {
        if (widget.onPressed == null) return;
        HapticFeedback.lightImpact();
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
              widget.onPressed != null && pressed
                  ? widget.decoration.color!.opacity * 0.8
                  : widget.decoration.color!.opacity,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
