import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ziggle/app/values/palette.dart';

class ScrollingPageIndicator extends StatefulWidget {
  final double dotSize;
  final double dotSelectedSize;
  final Color dotColor;
  final Color dotSelectedColor;
  final double dotSpacing;
  final int visibleDotCount;
  final int visibleDotThreshold;
  final int itemCount;
  final PageController controller;
  final Axis orientation;
  final bool reverse;

  const ScrollingPageIndicator({
    super.key,
    this.dotSize = 6.0,
    this.dotSelectedSize = 6.0,
    this.dotColor = Palette.textGrey,
    this.dotSelectedColor = Palette.primary100,
    this.dotSpacing = 12.0,
    this.visibleDotCount = 5,
    this.visibleDotThreshold = 2,
    required this.itemCount,
    required this.controller,
    this.orientation = Axis.horizontal,
    this.reverse = false,
  }) : assert(visibleDotCount % 2 != 0);

  @override
  State<StatefulWidget> createState() => _ScrollingPageIndicatorState();
}

class _ScrollingPageIndicatorState extends State<ScrollingPageIndicator>
    with SingleTickerProviderStateMixin {
  int? _skimmingFirstPage;
  int? _prevSkimmingPage;
  int? _lastPage;
  late final _animation = AnimationController(
    vsync: this,
    upperBound: widget.itemCount.toDouble() - 1,
  );

  @override
  void initState() {
    widget.controller.addListener(_onController);
    super.initState();
  }

  @override
  void didUpdateWidget(ScrollingPageIndicator oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onController);
      widget.controller.addListener(_onController);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onController);
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = min(widget.itemCount, widget.visibleDotCount);
    final width = (itemCount - 1) * widget.dotSpacing + widget.dotSelectedSize;
    final height = widget.dotSelectedSize;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: (details) {
        HapticFeedback.mediumImpact();
        setState(() => _skimmingFirstPage = _currentPage);
      },
      onLongPressEnd: (details) => setState(() => _skimmingFirstPage = null),
      onLongPressMoveUpdate: (details) {
        final page = _skimmingFirstPage! +
            (widget.reverse ? -1 : 1) *
                details.localPosition.dx ~/
                widget.dotSpacing;
        final clampPage = max(0, min(page, widget.itemCount - 1));
        if (clampPage != _prevSkimmingPage) {
          _prevSkimmingPage = clampPage;
          HapticFeedback.lightImpact();
          widget.controller.jumpToPage(clampPage);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: _skimmingFirstPage != null
            ? BoxDecoration(
                color: Palette.background200,
                borderRadius: BorderRadius.circular(100),
              )
            : null,
        child: SizedBox(
          width: widget.orientation == Axis.horizontal ? width : height,
          height: widget.orientation == Axis.vertical ? width : height,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => CustomPaint(
              painter: _Painter(widget, _animation.value),
            ),
          ),
        ),
      ),
    );
  }

  int get _currentPage {
    try {
      return widget.controller.page?.round() ?? 0;
    } catch (exception) {
      return 0;
    }
  }

  void _onController() {
    if (_lastPage != _currentPage) {
      _lastPage = _currentPage;
      _animation.animateTo(
        _currentPage.toDouble(),
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
    setState(() {});
  }
}

class _Painter extends CustomPainter {
  final double _page;
  final Axis _orientation;
  final double _firstDotOffset;
  final bool _reverse;
  final int _itemCount;
  final int _visibleDotCount;
  final int _visibleDotThreshold;
  final double _dotSize;
  final double _dotSelectedSize;
  final Color _dotColor;
  final Color _dotSelectedColor;
  final double _dotSpacing;

  _Painter(ScrollingPageIndicator widget, this._page)
      : _firstDotOffset = widget.itemCount > widget.visibleDotCount
            ? 0
            : widget.dotSelectedSize / 2,
        _orientation = widget.orientation,
        _reverse = widget.reverse,
        _visibleDotCount = widget.visibleDotCount,
        _visibleDotThreshold = widget.visibleDotThreshold,
        _dotSize = widget.dotSize,
        _dotSelectedSize = widget.dotSelectedSize,
        _dotColor = widget.dotColor,
        _dotSelectedColor = widget.dotSelectedColor,
        _dotSpacing = widget.dotSpacing,
        _itemCount = widget.itemCount;

  double get page {
    try {
      if (_reverse) return _itemCount - 1 - _page;
      return _page;
    } catch (exception) {
      return 0.0;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_itemCount < _visibleDotThreshold) {
      return;
    }
    final paint = Paint();
    double width = _orientation == Axis.horizontal ? size.width : size.height;
    double height = _orientation == Axis.vertical ? size.width : size.height;

    final visibleFramePosition = _getVisibleFramePosition(page, width);

    // Some empirical coefficients
    double scaleDistance =
        (_dotSpacing + (_dotSelectedSize - _dotSize) / 2) * 0.4;
    double smallScaleDistance = _dotSelectedSize / 2;

    int firstVisibleDotPos =
        ((visibleFramePosition - _firstDotOffset) / _dotSpacing).floor();
    int lastVisibleDotPos = firstVisibleDotPos +
        ((visibleFramePosition + width - getDotOffsetAt(firstVisibleDotPos)) /
                _dotSpacing)
            .floor();

    // If real dots count is less than we can draw inside visible frame, we move lastVisibleDotPos
    // to the last item
    if (firstVisibleDotPos == 0 && lastVisibleDotPos + 1 > _itemCount) {
      lastVisibleDotPos = _itemCount - 1;
    }

    for (int i = firstVisibleDotPos; i <= lastVisibleDotPos; i++) {
      double dot = getDotOffsetAt(i);
      if (dot >= visibleFramePosition && dot < visibleFramePosition + width) {
        double diameter;
        double scale;

        // Calculate scale according to current page position
        scale = getDotScaleAt(i);
        diameter = lerpDouble(_dotSize, _dotSelectedSize, scale)!;

        // Additional scale for dots at corners
        if (_itemCount > _visibleDotCount) {
          double currentScaleDistance;
          if ((i == 0 || i == _itemCount - 1)) {
            currentScaleDistance = smallScaleDistance;
          } else {
            currentScaleDistance = scaleDistance;
          }

          if (dot - visibleFramePosition < currentScaleDistance) {
            double calculatedDiameter =
                diameter * (dot - visibleFramePosition) / currentScaleDistance;
            diameter = min(diameter, calculatedDiameter);
          } else if (dot - visibleFramePosition >
              width - currentScaleDistance) {
            double calculatedDiameter = diameter *
                (-dot + visibleFramePosition + width) /
                currentScaleDistance;
            diameter = min(diameter, calculatedDiameter);
          }
        }

        paint.color = Color.lerp(_dotColor, _dotSelectedColor, scale)!;

        if (_orientation == Axis.horizontal) {
          canvas.drawCircle(Offset(dot - visibleFramePosition, height / 2),
              diameter / 2, paint);
        } else {
          canvas.drawCircle(Offset(height / 2, dot - visibleFramePosition),
              diameter / 2, paint);
        }
      }
    }
  }

  double getDotOffsetAt(int index) {
    return _firstDotOffset + index * _dotSpacing;
  }

  double getDotScaleAt(int index) {
    int position = page.floor();
    double offset = page - position;
    if (index == position) {
      return 1 - offset.abs();
    } else if (index == position + 1 && position < _itemCount - 1) {
      return 1 - (1 - offset).abs();
    }
    return 0;
  }

  double _getVisibleFramePosition(double page, double width) {
    final position = page.floor();
    final offset = page - position;
    if (_itemCount <= _visibleDotCount) {
      return 0;
    }

    final center = getDotOffsetAt(position) + _dotSpacing * offset;
    final absolute = center - width / 2;

    // Block frame offset near start and end
    int firstCenteredDotIndex = (_visibleDotCount / 2).floor();
    double lastCenteredDot =
        getDotOffsetAt(_itemCount - 1 - firstCenteredDotIndex);
    if (absolute + width / 2 < getDotOffsetAt(firstCenteredDotIndex)) {
      return getDotOffsetAt(firstCenteredDotIndex) - width / 2;
    } else if (absolute + width / 2 > lastCenteredDot) {
      return lastCenteredDot - width / 2;
    }
    return absolute;
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return oldDelegate._page != _page;
  }
}
