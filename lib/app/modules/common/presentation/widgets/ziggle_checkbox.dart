import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleCheckbox extends StatelessWidget {
  const ZiggleCheckbox({
    super.key,
    required this.isChecked,
    required this.onToggle,
    this.loading = false,
    this.disabled = false,
  });

  final bool isChecked;
  final ValueChanged<bool> onToggle;
  final bool loading;
  final bool disabled;

  void _handleCheck() {
    if (disabled || loading) return;
    onToggle(!isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleCheck,
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          color: isChecked ? Palette.primary : Palette.white,
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
            color: isChecked ? Palette.primary : Palette.gray,
            width: 1.5,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: isChecked ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 100),
            child: const Icon(
              Icons.check,
              color: Palette.white,
              size: 24.0 * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
