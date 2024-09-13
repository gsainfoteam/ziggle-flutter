import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/values/palette.dart';

class ZiggleBottomNavigationPage extends StatefulWidget {
  const ZiggleBottomNavigationPage({
    super.key,
    required this.child,
    required this.items,
  });

  final StatefulNavigationShell child;
  final List<BottomNavigationBarItem> items;

  @override
  State<ZiggleBottomNavigationPage> createState() =>
      _ZiggleBottomNavigationPageState();
}

class _ZiggleBottomNavigationPageState
    extends State<ZiggleBottomNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Palette.grayBorder)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: widget.items.indexed
                  .map(
                    (e) => Expanded(
                      child: ZigglePressable(
                        onPressed: () => widget.child.goBranch(
                          e.$1,
                          initialLocation: e.$1 == widget.child.currentIndex,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 24,
                                child: widget.child.currentIndex == e.$1
                                    ? e.$2.activeIcon
                                    : e.$2.icon,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
