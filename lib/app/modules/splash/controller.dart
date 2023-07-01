import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:ziggle/app/routes/pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _init();
  }

  _init() async {
    await 3.delay();
    FlutterNativeSplash.remove();
    Get.offAllNamed(Routes.MY_PAGE);
  }
}
