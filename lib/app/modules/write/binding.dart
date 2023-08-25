import 'package:get/get.dart';
import 'package:ziggle/app/modules/write/controller.dart';
import 'package:ziggle/app/modules/write/repository.dart';

class WriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WriteController(WriteRepository(Get.find(), Get.find())));
  }
}
