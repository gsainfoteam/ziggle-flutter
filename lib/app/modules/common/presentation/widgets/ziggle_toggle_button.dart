import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleToggleButton extends StatefulWidget {
  const ZiggleToggleButton({
    super.key,
    required this.onToggle,
    this.initialState = false,
    this.loading = false,
    this.disabled = false,
    this.activeColor = Palette.primary,
    this.inactiveColor = Palette.gray,
    this.thumbColor = Palette.white,
    this.trackWidth = 40.0,
    this.trackHeight = 22.0,
    this.thumbSize = 17.0,
  });

  final ValueChanged<bool> onToggle;
  final bool initialState;
  final bool loading;
  final bool disabled;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double trackHeight;
  final double trackWidth;
  final double thumbSize;

  @override
  State<ZiggleToggleButton> createState() => _ZiggleToggleButtonState();
}

class _ZiggleToggleButtonState extends State<ZiggleToggleButton> {
  bool _switched = false;

  @override
  void initState() {
    super.initState();
    _switched = widget.initialState;
  }

  void _handleSwitch() {
    if (widget.disabled || widget.loading) return;
    setState(() {
      _switched = !_switched;
    });
    widget.onToggle(_switched);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleSwitch,
      child: Container(
        width: widget.trackWidth,
        height: widget.trackHeight,
        decoration: BoxDecoration(
          color: _switched ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(widget.trackHeight / 2),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn,
              left: _switched ? widget.trackWidth - widget.thumbSize - 3 : 3,
              top: 2.5,
              bottom: 2.5,
              child: Container(
                width: widget.thumbSize,
                height: widget.thumbSize,
                decoration: BoxDecoration(
                  color: widget.thumbColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
