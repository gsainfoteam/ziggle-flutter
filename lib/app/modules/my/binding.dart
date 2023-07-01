import 'package:get/get.dart';
import 'package:ziggle/app/modules/my/controller.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyController());
  }
}
