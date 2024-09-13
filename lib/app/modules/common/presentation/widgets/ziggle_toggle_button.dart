import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleToggleButton extends StatefulWidget {
  const ZiggleToggleButton({
    super.key,
    required this.onToggle,
    required this.value,
    this.loading = false,
    this.disabled = false,
  });

  final ValueChanged<bool> onToggle;
  final bool value;
  final bool loading;
  final bool disabled;

  @override
  State<ZiggleToggleButton> createState() => _ZiggleToggleButtonState();
}

class _ZiggleToggleButtonState extends State<ZiggleToggleButton> {
  void _handleSwitch() {
    if (widget.disabled || widget.loading) return;
    widget.onToggle(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleSwitch,
      child: Container(
        width: 40.0,
        height: 22.0,
        decoration: BoxDecoration(
          color: widget.value ? Palette.primary : Palette.gray,
          borderRadius: BorderRadius.circular(22.0 / 2),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn,
              alignment:
                  widget.value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Container(
                  width: 17.0,
                  height: 17.0,
                  decoration: const BoxDecoration(
                    color: Palette.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
