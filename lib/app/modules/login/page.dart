import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/theme/text.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/login/controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  '지스트의 모든 공지를 한눈에',
                  textAlign: TextAlign.center,
                  style: TextStyles.articleTitleStyle,
                ),
              ),
            ),
            const Expanded(child: SizedBox.shrink()),
            Obx(() => SizedBox(
                  height: 50,
                  child: ZiggleButton(
                    text: 'GSA 통합 계정으로 로그인',
                    onTap: controller.login,
                    loading: controller.loading.value,
                    fontSize: 18,
                  ),
                )),
            const SizedBox(height: 16),
            ZiggleButton(
              text: '로그인 없이 시작하기',
              color: Colors.transparent,
              onTap: controller.skipLogin,
            )
          ],
        ).paddingAll(20),
      ),
    );
  }
}
