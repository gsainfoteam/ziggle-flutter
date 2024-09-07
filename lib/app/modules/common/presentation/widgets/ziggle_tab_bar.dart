import 'package:flutter/material.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleTabBar extends StatelessWidget {
  const ZiggleTabBar({
    super.key,
    this.controller,
    required this.tabs,
  });

  final TabController? controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs,
      controller: controller,
      indicatorColor: Palette.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 3,
      dividerHeight: 3,
      unselectedLabelColor: Palette.gray,
      dividerColor: Palette.gray,
      splashFactory: NoSplash.splashFactory,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      labelPadding: const EdgeInsets.symmetric(vertical: 10),
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Palette.primary,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Palette.gray,
      ),
    );
  }
}
