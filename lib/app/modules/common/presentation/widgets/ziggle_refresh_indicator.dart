import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const ZiggleRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Palette.primary,
      backgroundColor: Palette.white,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
