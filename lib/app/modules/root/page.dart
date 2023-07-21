import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/home/page.dart';
import 'package:ziggle/app/modules/root/controller.dart';
import 'package:ziggle/app/modules/search/page.dart';
import 'package:ziggle/app/modules/write/page.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class RootPage extends GetView<RootController> {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Assets.logo.icon
            .image(alignment: Alignment.centerLeft)
            .paddingSymmetric(horizontal: 8),
        actions: [
          SizedBox(
            height: 45,
            child: ZiggleButton(
              color: Colors.transparent,
              onTap: controller.goToProfile,
              child: Obx(() {
                final name = controller.name.value;
                if (name == null) {
                  return Row(children: [Text(t.root.login)]);
                }
                return Row(
                  children: [
                    Text(
                      name,
                      style: TextStyles.titleTextStyle.copyWith(
                        color: Palette.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Assets.icons.profile.image(),
                  ],
                );
              }),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Palette.placeholder)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 100),
            Expanded(
              child: Obx(
                () => BottomNavigationBar(
                  onTap: controller.onChangeIndex,
                  currentIndex: controller.pageIndex.value,
                  items: [
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.home), label: t.root.main),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.search), label: t.root.search),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.edit), label: t.root.write),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 100),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: controller.pageController,
          onPageChanged: controller.pageIndex,
          children: const [HomePage(), SearchPage(), WritePage()],
        ),
      ),
    );
  }
}
