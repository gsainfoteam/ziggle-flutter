import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/colors.dart';

class BoardAnimation extends StatelessWidget {
  const BoardAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _BoardAnimation(constraints),
    );
  }
}

class _BoardAnimation extends StatefulWidget {
  final BoxConstraints constraints;

  const _BoardAnimation(this.constraints);

  @override
  State<_BoardAnimation> createState() => _BoardAnimationState();
}

class _BoardAnimationState extends State<_BoardAnimation> {
  final _width = (Get.width + 108) / 3;
  late final _dx = _width + 12;
  late final _maxHeight = widget.constraints.maxHeight;

  final _rects = <Rect>[];

  @override
  void initState() {
    super.initState();
    _rects.addAll(
      List.generate(
        4,
        (index) => Rect.fromLTWH(0, -30, _width, _maxHeight)
            .translate(-65 + _dx * index, -50.0 * (3 - index)),
      ),
    );
    Timer.periodic(const Duration(milliseconds: 10), _period);
  }

  void _period(_) {
    setState(() {
      for (var i = 0; i < _rects.length; i++) {
        final rect = _rects[i];
        _rects[i] = rect.translate(0.2, 0);
        if (rect.left > Get.width) {
          _rects[i] = Rect.fromLTRB(
            rect.left - _dx * 4,
            -10 - Random().nextDouble() * 200,
            rect.right - _dx * 4,
            _maxHeight - Random().nextDouble() * 100,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _rects
          .expand((rect) => [
                rect.copyWith(bottom: rect.center.dy - 6),
                rect.copyWith(top: rect.center.dy + 6),
              ])
          .map((rect) => _Article(rect: rect))
          .toList(),
    );
  }
}

class _Article extends StatelessWidget {
  final Rect rect;

  const _Article({required this.rect});

  @override
  Widget build(BuildContext context) {
    final opacity = (rect.left / Get.width) / 2.5 + 0.5;
    return Positioned.fromRect(
      rect: rect,
      child: Container(
        decoration: BoxDecoration(
          color: Palette.primaryColor.withOpacity(opacity),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

extension _RectCopy on Rect {
  Rect copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) =>
      Rect.fromLTRB(
        left ?? this.left,
        top ?? this.top,
        right ?? this.right,
        bottom ?? this.bottom,
      );
}
