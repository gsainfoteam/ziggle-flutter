import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/global_widgets/button.dart';
import 'package:ziggle/app/modules/home/controller.dart';
import 'package:ziggle/app/routes/pages.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ZiggleButton(
        onTap: () => Get.toNamed(Routes.ARTICLE, parameters: {'id': '1'}),
        text: 'sample article',
      ),
    );
  }
}
