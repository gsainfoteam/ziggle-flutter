import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverPinnedBoxAdapter extends SingleChildRenderObjectWidget {
  const SliverPinnedBoxAdapter({
    super.key,
    super.child,
    this.pinned = true,
  });

  final bool pinned;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliverPinnedBoxAdapter(pinned: pinned);
}

class _RenderSliverPinnedBoxAdapter extends RenderSliverSingleBoxAdapter {
  _RenderSliverPinnedBoxAdapter({required this.pinned});

  final bool pinned;

  double previousScrollOffset = 0;
  double? ratchetingScrollDistance;

  @override
  void performLayout() {
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final childExtent = constraints.axis == Axis.horizontal
        ? child!.size.width
        : child!.size.height;
    final paintedChildExtent = min(
      childExtent,
      constraints.remainingPaintExtent - constraints.overlap,
    );

    final dy = previousScrollOffset - constraints.scrollOffset;
    previousScrollOffset = constraints.scrollOffset;

    ratchetingScrollDistance = ratchetingScrollDistance == null
        ? childExtent
        : (ratchetingScrollDistance! + dy).clamp(0.0, childExtent);

    geometry = SliverGeometry(
      paintExtent: paintedChildExtent,
      maxPaintExtent: childExtent,
      maxScrollObstructionExtent: childExtent,
      paintOrigin: pinned ? constraints.overlap : -constraints.scrollOffset,
      scrollExtent: childExtent,
      layoutExtent: max(0, paintedChildExtent - constraints.scrollOffset),
      hasVisualOverflow: paintedChildExtent < childExtent,
    );
  }

  @override
  bool hitTestSelf(
          {required double mainAxisPosition,
          required double crossAxisPosition}) =>
      true;
}
