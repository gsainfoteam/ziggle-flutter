import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/values/colors.dart';

const _kGap = 12.0;
const _kWidth = 160.0;

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
  late final Timer _timer;
  final _rects = <Rect>[];
  var speed = 10.0;

  @override
  void initState() {
    super.initState();
    _period();
    _timer = Timer.periodic(const Duration(milliseconds: 10), _period);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _period([_]) {
    setState(() {
      final maxHeight = widget.constraints.maxHeight;

      while (_rects.isEmpty || _rects.last.left > 0) {
        final lastLeft = _rects.isEmpty ? 0 : _rects.last.left;
        final left = lastLeft - _kWidth - _kGap;
        final right = left + _kWidth;

        final rects = <Rect>[];
        while (rects.isEmpty || rects.last.bottom < maxHeight) {
          final lastBottom = rects.isEmpty ? -30.0 : rects.last.bottom;
          final top = lastBottom + _kGap;
          final bottom = top + Random().nextDouble() * 100 + 100;
          rects.add(
            Rect.fromLTRB(
              left,
              lastBottom + _kGap,
              right,
              bottom,
            ),
          );
        }
        rects.removeLast();
        _rects.addAll(rects);
      }

      if (_rects.first.right < widget.constraints.maxWidth) {
        speed /= 0.95;
      } else if (speed > 0.2) {
        speed *= 0.95;
      }
      _rects.removeWhere((rect) => rect.left > widget.constraints.maxWidth);
      for (var i = 0; i < _rects.length; i++) {
        final rect = _rects[i];
        _rects[i] = rect.translate(speed, 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _rects.map((rect) => _Article(rect: rect)).toList(),
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

// extension _RectCopy on Rect {
//   Rect copyWith({
//     double? left,
//     double? top,
//     double? right,
//     double? bottom,
//   }) =>
//       Rect.fromLTRB(
//         left ?? this.left,
//         top ?? this.top,
//         right ?? this.right,
//         bottom ?? this.bottom,
//       );
// }
