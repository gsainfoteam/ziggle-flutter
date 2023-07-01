import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleImageController extends GetxController {
  final RxInt page = (Get.arguments['page'] as int).obs;
  final List<String> images = Get.arguments['images'];
  late final pageController = PageController(initialPage: page.value - 1);

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      page.value = (pageController.page?.toInt() ?? 0) + 1;
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    pageController.animateToPage(
      page - 1,
      duration: 300.milliseconds,
      curve: Curves.easeOut,
    );
  }
}
