import 'package:get/get.dart';
import 'package:ziggle/app/modules/profile/controller.dart';
import 'package:ziggle/app/modules/profile/repository.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController(ProfileRepository(Get.find())));
  }
}
