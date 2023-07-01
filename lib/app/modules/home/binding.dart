import 'package:get/get.dart';
import 'package:ziggle/app/modules/home/controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
