import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/common/presentaion/widgets/button.dart';
import 'package:ziggle/app/core/values/palette.dart';

const _kGap = 12.0;
const _kWidth = 160.0;

class BoardAnimation extends StatelessWidget {
  final VoidCallback? openHidden;
  const BoardAnimation({super.key, this.openHidden});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          _BoardAnimation(constraints, openHidden),
    );
  }
}

class _BoardAnimation extends StatefulWidget {
  final BoxConstraints constraints;
  final VoidCallback? openHidden;

  const _BoardAnimation(this.constraints, this.openHidden);

  @override
  State<_BoardAnimation> createState() => _BoardAnimationState();
}

class _BoardAnimationState extends State<_BoardAnimation> {
  late final Timer _timer;
  final _rects = <Rect>[];
  var speed = 10.0;
  final _clicks = <double>[];

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
      final maxWidth = widget.constraints.maxWidth;

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

      if (_rects.first.right < maxWidth) {
        speed /= 0.95;
      } else if (speed > 0.2) {
        speed *= 0.95;
      }
      _rects.removeWhere((rect) => rect.left > maxWidth + _kWidth);
      for (var i = 0; i < _rects.length; i++) {
        final rect = _rects[i];
        _rects[i] = rect.translate(speed, 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _rects
          .map((rect) => _Article(
                rect: rect,
                onTap: _checkHidden,
              ))
          .toList(),
    );
  }

  void _checkHidden(opacity) {
    _clicks.add(opacity);
    final zip = IterableZip([
      _clicks.reversed.take(2),
      _clicks.reversed.skip(1).take(2),
    ]);
    final opacityCondition =
        zip.every((element) => element.first - element.last > 0.1);
    final countCondition = zip.length == 2;
    if (!opacityCondition || !countCondition) return;
    widget.openHidden?.call();
  }
}

class _Article extends StatelessWidget {
  final Rect rect;
  final void Function(double opacity)? onTap;

  const _Article({required this.rect, this.onTap});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final opacity = max(0.0, min((rect.left / width) / 2.5 + 0.5, 1.0));
    return Positioned.fromRect(
      rect: rect,
      child: ZiggleButton(
        onTap: () => onTap?.call(opacity),
        padding: EdgeInsets.zero,
        color: Palette.primaryColor.withOpacity(opacity),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
