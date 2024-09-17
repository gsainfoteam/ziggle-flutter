import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ziggle/app/modules/common/presentation/widgets/ziggle_pressable.dart';
import 'package:ziggle/app/router.gr.dart';
import 'package:ziggle/app/values/palette.dart';
import 'package:ziggle/gen/assets.gen.dart';

@RoutePage()
class ZiggleBottomNavigationPage extends StatelessWidget {
  const ZiggleBottomNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [
        FeedRoute(),
        CategoryRoute(),
        CategoryRoute(),
        FeedRoute(),
        FeedRoute(),
      ],
      builder: (context, child, tabController) => Scaffold(
        body: child,
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
                children: [
                  BottomNavigationBarItem(
                    icon: Assets.icons.feed.svg(),
                    activeIcon: Assets.icons.feedActive.svg(),
                  ),
                  BottomNavigationBarItem(
                    icon: Assets.icons.category.svg(),
                    activeIcon: Assets.icons.categoryActive.svg(),
                  ),
                  BottomNavigationBarItem(
                    icon: Assets.icons.favorite.svg(),
                    activeIcon: Assets.icons.favoriteActive.svg(),
                  ),
                  BottomNavigationBarItem(
                    icon: Assets.icons.profile.svg(),
                    activeIcon: Assets.icons.profileActive.svg(),
                  ),
                ]
                    .indexed
                    .map(
                      (e) => Expanded(
                        child: ZigglePressable(
                          onPressed: () => tabController.animateTo(e.$1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 24,
                                  child: tabController.index == e.$1
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
      ),
    );
  }
}
