import 'package:get/get.dart';
import 'package:ziggle/app/modules/splash/controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
