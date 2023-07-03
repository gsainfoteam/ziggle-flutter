import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/login/controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => ZiggleButton(
                  text: 'Login with IdP',
                  onTap: controller.login,
                  loading: controller.loading.value,
                )),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: controller.code,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Code',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => ZiggleButton(
                      text: 'Login with Code',
                      onTap: controller.loginWithCode,
                      loading: controller.loading.value,
                    )),
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 20),
      ),
    );
  }
}
