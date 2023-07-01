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
        child: ZiggleButton(
          text: 'Login with IdP',
          onTap: controller.login,
        ),
      ),
    );
  }
}
