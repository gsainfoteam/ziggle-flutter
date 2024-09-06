import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleCheckbox extends StatefulWidget {
  const ZiggleCheckbox({
    super.key,
    required this.onToggle,
    this.initialState = false,
    this.loading = false,
    this.disabled = false,
    this.activeColor = Palette.primary,
    this.inactiveColor = Palette.white,
    this.checkmarkColor = Palette.white,
    this.borderColor = Palette.gray,
    this.size = 24.0,
  });

  final ValueChanged<bool> onToggle;
  final bool initialState;
  final bool loading;
  final bool disabled;
  final Color activeColor;
  final Color inactiveColor;
  final Color checkmarkColor;
  final Color borderColor;
  final double size;

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
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _checked ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(7.0),
          border: Border.all(
            color: _checked ? widget.activeColor : widget.borderColor,
            width: 1.5,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: _checked ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 100),
            child: Icon(
              Icons.check,
              color: widget.checkmarkColor,
              size: widget.size * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
