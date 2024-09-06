import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class LanguageToggle extends StatefulWidget {
  const LanguageToggle({
    super.key,
    required this.onToggle,
    this.initialState = false,
    this.loading = false,
    this.disabled = false,
    this.activeColor = Palette.primary,
    this.inactiveColor = Palette.gray,
    this.trackColor = Palette.grayMedium,
    this.thumbColor = Palette.white,
    this.trackWidth = 147.0,
    this.trackHeight = 39.0,
    this.kThumbWidth = 62.0,
    this.eThumbWidth = 73.0,
    this.thumbHeight = 29.0,
  });

  final ValueChanged<bool> onToggle;
  final bool initialState;
  final bool loading;
  final bool disabled;
  final Color activeColor;
  final Color inactiveColor;
  final Color trackColor;
  final Color thumbColor;
  final double trackHeight;
  final double trackWidth;
  final double thumbHeight;
  final double kThumbWidth;
  final double eThumbWidth;

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
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
          color: widget.trackColor,
          borderRadius: BorderRadius.circular(widget.trackHeight / 2),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn,
              left: _switched ? widget.trackWidth - widget.eThumbWidth - 5 : 5,
              top: 5,
              bottom: 5,
              child: Container(
                width: _switched ? widget.eThumbWidth : widget.kThumbWidth,
                height: widget.thumbHeight,
                decoration: BoxDecoration(
                    color: widget.thumbColor,
                    borderRadius:
                        BorderRadius.circular(widget.thumbHeight / 2)),
                child: Center(
                  child: Text(
                    _switched ? 'English' : '한국어',
                    style: TextStyle(
                      color: widget.activeColor,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 0),
              left: _switched ? 5 : widget.trackWidth - widget.eThumbWidth - 5,
              top: 5,
              bottom: 5,
              child: SizedBox(
                width: _switched ? widget.kThumbWidth : widget.eThumbWidth,
                height: widget.thumbHeight,
                child: Center(
                  child: Text(
                    _switched ? '한국어' : 'English',
                    style: TextStyle(
                      color: widget.inactiveColor,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
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
