import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/home/controller.dart';
import 'package:ziggle/gen/assets.gen.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

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
    );
  }
}
