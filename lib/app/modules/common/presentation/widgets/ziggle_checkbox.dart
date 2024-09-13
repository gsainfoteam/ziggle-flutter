import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleCheckbox extends StatefulWidget {
  const ZiggleCheckbox({
    super.key,
    required this.onToggle,
    this.initialState = false,
    this.loading = false,
    this.disabled = false,
  });

  final ValueChanged<bool> onToggle;
  final bool initialState;
  final bool loading;
  final bool disabled;

  @override
  State<ZiggleCheckbox> createState() => _ZiggleCheckboxState();
}

class _ZiggleCheckboxState extends State<ZiggleCheckbox> {
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checked = widget.initialState;
  }

  void _handleCheck() {
    if (widget.disabled || widget.loading) return;
    setState(() {
      _checked = !_checked;
    });
    widget.onToggle(_checked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleCheck,
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          color: _checked ? Palette.primary : Palette.white,
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
            color: _checked ? Palette.primary : Palette.gray,
            width: 1.5,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: _checked ? 1.0 : 0.0,
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
