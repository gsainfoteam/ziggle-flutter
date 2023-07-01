import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/home/home_page.dart';
import 'package:ziggle/app/modules/home/root_controller.dart';
import 'package:ziggle/gen/assets.gen.dart';

class RootPage extends GetView<RootController> {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Assets.logo.icon
            .image(alignment: Alignment.centerLeft)
            .paddingSymmetric(
              horizontal: 15,
              vertical: 10,
            ),
        actions: [
          ZiggleButton(
            color: Colors.transparent,
            onTap: controller.goToProfile,
            child: Row(
              children: [
                Text(
                  'SUYEON',
                  style: TextStyles.titleTextStyle.copyWith(
                    color: Palette.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Assets.icons.profile.image(),
              ],
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
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: '메인'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search), label: '검색'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.edit), label: '작성'),
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
          children: const [HomePage(), HomePage(), HomePage()],
        ),
      ),
    );
  }
}
