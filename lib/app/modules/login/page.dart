import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/login/controller.dart';
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
            Expanded(
              child: Center(
                child: Text(
                  t.login.promotion,
                  textAlign: TextAlign.center,
                  style: TextStyles.articleTitleStyle,
                ),
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
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
            )
          ],
        ).paddingAll(20),
      ),
    );
  }
}
