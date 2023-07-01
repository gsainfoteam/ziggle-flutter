import 'package:get/get.dart';
import 'package:ziggle/app/modules/login/controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
