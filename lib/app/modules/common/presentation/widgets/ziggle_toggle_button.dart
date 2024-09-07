import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleToggleButton extends StatefulWidget {
  const ZiggleToggleButton({
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
        width: 40.0,
        height: 22.0,
        decoration: BoxDecoration(
          color: _switched ? Palette.primary : Palette.gray,
          borderRadius: BorderRadius.circular(22.0 / 2),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn,
              left: _switched ? 40.0 - 17.0 - 3.0 : 3.0,
              top: 2.5,
              bottom: 2.5,
              child: Container(
                width: 17.0,
                height: 17.0,
                decoration: const BoxDecoration(
                  color: Palette.white,
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
