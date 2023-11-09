import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/core/routes/routes.dart';
import 'package:ziggle/app/data/services/analytics/service.dart';
import 'package:ziggle/app/data/services/user/service.dart';

class RootController extends GetxController {
  final pageIndex = 0.obs;
  final pageController = PageController();
  final _userService = UserService.to;
  final _analyticsService = AnalyticsService.to;
  final name = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  _load() async {
    final user = await _userService.getUserInfo().first;
    if (user == null) {
      return;
    }

    name.value = user.name;
  }

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
    _analyticsService.logChangePage(
      [Paths.home, Paths.search, Paths.write][page],
    );
  }

  void goToProfile() {
    if (name.value == null) {
      _userService.logout();
      _analyticsService.logLogoutAnonymous();
      return;
    }
    Get.toNamed(Paths.profile);
  }
}
