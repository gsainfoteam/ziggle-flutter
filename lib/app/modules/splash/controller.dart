import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/data/services/user/service.dart';

class SplashController extends GetxController {
  final _userService = UserService.to;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  _init() async {
    try {
      await _userService.getUserInfo().first;
      await Get.defaultTransitionDuration.delay();
    } finally {
      FlutterNativeSplash.remove();
    }
  }
}
