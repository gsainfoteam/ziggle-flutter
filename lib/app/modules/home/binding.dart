import 'package:get/get.dart';
import 'package:ziggle/app/modules/home/home_controller.dart';
import 'package:ziggle/app/modules/home/root_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RootController());
    Get.lazyPut(() => HomeController());
  }
}
