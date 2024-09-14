import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ziggle/app/values/palette.dart';

const _padding = EdgeInsets.all(5);
const _thumbPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
const _gap = 2;

class LanguageToggle extends StatefulWidget {
  const LanguageToggle({
    super.key,
    required this.onToggle,
    required this.value,
    this.loading = false,
    this.disabled = false,
    this.activeColor = Palette.primary,
    this.inactiveColor = Palette.gray,
    this.trackColor = Palette.grayMedium,
    this.thumbColor = Palette.white,
  });

  final ValueChanged<bool> onToggle;
  final bool value;
  final bool loading;
  final bool disabled;
  final Color activeColor;
  final Color inactiveColor;
  final Color trackColor;
  final Color thumbColor;

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );
  late final _position = CurvedAnimation(
    curve: Curves.easeIn,
    reverseCurve: Curves.easeOut,
    parent: _animationController,
  );

  void _handleSwitch() {
    if (widget.disabled || widget.loading) return;
    widget.onToggle(!widget.value);
  }

  @override
  void didUpdateWidget(covariant LanguageToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleSwitch,
      child: AnimatedBuilder(
        animation: _position,
        builder: (context, _) => _Toggle(
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          trackColor: widget.trackColor,
          thumbColor: widget.thumbColor,
          position: _position.value,
        ),
      ),
    );
  }
}

class _Toggle extends SingleChildRenderObjectWidget {
  final Color activeColor;
  final Color inactiveColor;
  final Color trackColor;
  final Color thumbColor;
  final double position;

  const _Toggle({
    required this.activeColor,
    required this.inactiveColor,
    required this.trackColor,
    required this.thumbColor,
    required this.position,
  });

  @override
  void updateRenderObject(
      BuildContext context, covariant _ToggleRenderBox renderObject) {
    renderObject
      ..activeColor = activeColor
      ..inactiveColor = inactiveColor
      ..trackColor = trackColor
      ..thumbColor = thumbColor
      ..position = position;
  }

  @override
  RenderObject createRenderObject(BuildContext context) => _ToggleRenderBox(
        activeColor,
        inactiveColor,
        trackColor,
        thumbColor,
        position,
      );
}

class _ToggleRenderBox extends RenderShiftedBox {
  Color get activeColor => _activeColor;
  Color _activeColor;
  set activeColor(Color value) {
    _activeColor = value;
    markNeedsPaint();
  }

  Color get inactiveColor => _inactiveColor;
  Color _inactiveColor;
  set inactiveColor(Color value) {
    _inactiveColor = value;
    markNeedsPaint();
  }

  Color get trackColor => _trackColor;
  Color _trackColor;
  set trackColor(Color value) {
    _trackColor = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    _thumbColor = value;
    markNeedsPaint();
  }

  double get position => _position;
  double _position;
  set position(double value) {
    _position = value;
    markNeedsPaint();
  }

  static TextPainter _makeTextPainter(String text, Color color) => TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: 16,
            leadingDistribution: TextLeadingDistribution.even,
            height: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

  late final _englishPainter = _makeTextPainter('English', inactiveColor);
  late final _koreanPainter = _makeTextPainter('한국어', inactiveColor);

  _ToggleRenderBox(
    this._activeColor,
    this._inactiveColor,
    this._trackColor,
    this._thumbColor,
    this._position,
  ) : super(null);

  void _paintTrack(Canvas canvas, Rect rect) {
    final trackRRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(rect.shortestSide / 2),
    );
    canvas.drawRRect(trackRRect, Paint()..color = trackColor);
    _koreanPainter.paint(
      canvas,
      Alignment.centerLeft
              .withinRect((_padding + _thumbPadding).deflateRect(rect)) -
          Offset(0, _koreanPainter.height / 2),
    );
    _englishPainter.paint(
      canvas,
      Alignment.centerRight
              .withinRect((_padding + _thumbPadding).deflateRect(rect)) -
          Offset(_englishPainter.width, _englishPainter.height / 2),
    );
  }

  void _paintThumb(Canvas canvas, Rect rect) {
    final koreanRect = Alignment.centerLeft
        .inscribe(_thumbPadding.inflateSize(_koreanPainter.size), rect);
    final englishRect = Alignment.centerRight
        .inscribe(_thumbPadding.inflateSize(_englishPainter.size), rect);
    final trackRRect = RRect.fromRectAndRadius(
      Rect.lerp(koreanRect, englishRect, position)!,
      Radius.circular(rect.shortestSide / 2),
    );
    canvas.drawRRect(trackRRect, Paint()..color = thumbColor);
    canvas.saveLayer(
      rect,
      Paint()..colorFilter = ColorFilter.mode(activeColor, BlendMode.srcIn),
    );
    canvas.clipRRect(trackRRect);
    _koreanPainter.paint(
      canvas,
      Alignment.centerLeft.withinRect(_thumbPadding.deflateRect(rect)) -
          Offset(0, _koreanPainter.height / 2),
    );
    _englishPainter.paint(
      canvas,
      Alignment.centerRight.withinRect(_thumbPadding.deflateRect(rect)) -
          Offset(_englishPainter.width, _englishPainter.height / 2),
    );
    canvas.restore();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _paintTrack(context.canvas, offset & size);
    _paintThumb(
      context.canvas,
      (offset + _padding.topLeft) & _padding.deflateSize(size),
    );
  }

  @override
  void performLayout() {
    _englishPainter.layout();
    _koreanPainter.layout();
    size = Size(
      _koreanPainter.width +
          _gap +
          _englishPainter.width +
          _padding.horizontal +
          _thumbPadding.horizontal * 2,
      max(_englishPainter.height, _koreanPainter.height) +
          _thumbPadding.vertical +
          _padding.vertical,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.shortestSide / 2),
    ).contains(position);
  }
}
