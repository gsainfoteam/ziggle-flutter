import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/core/values/colors.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/login/controller.dart';
import 'package:ziggle/gen/assets.gen.dart';
import 'package:ziggle/gen/strings.g.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(child: SizedBox.shrink()),
            _buildText(),
            const SizedBox(height: 100),
            Obx(() => SizedBox(
                  height: 50,
                  child: ZiggleButton(
                    text: t.login.login,
                    onTap: controller.login,
                    loading: controller.loading.value,
                    fontSize: 18,
                  ),
                )),
            const SizedBox(height: 16),
            ZiggleButton(
              text: t.login.withoutLogin,
              color: Colors.transparent,
              onTap: controller.skipLogin,
              textStyle: TextStyles.link,
            )
          ],
        ).paddingAll(20),
      ),
    );
  }

  Column _buildText() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    child: Assets.logo.icon.image(height: 100),
                  ),
                ],
              ),
            ),
            Assets.logo.text.image(height: 100),
          ],
        ),
        Text.rich(
          t.login.promotion(
            red: (text) => TextSpan(
              text: text,
              style: const TextStyle(color: Palette.primaryColor),
            ),
          ),
          textAlign: TextAlign.center,
          style: TextStyles.articleTitleStyle,
        )
      ],
    );
  }
}
