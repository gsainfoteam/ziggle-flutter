import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/routes/pages.dart';

class RootController extends GetxController {
  final pageIndex = 0.obs;
  final pageController = PageController();

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onChangeIndex(int page) {
    pageIndex.value = page;
    pageController.animateToPage(
      page,
      duration: 200.milliseconds,
      curve: Curves.easeOut,
    );
  }

  void goToProfile() => Get.toNamed(Routes.MY_PAGE);
}
