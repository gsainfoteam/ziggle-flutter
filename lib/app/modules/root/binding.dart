import 'package:get/get.dart';
import 'package:ziggle/app/modules/home/controller.dart';
import 'package:ziggle/app/modules/home/repository.dart';
import 'package:ziggle/app/modules/root/controller.dart';
import 'package:ziggle/app/modules/search/controller.dart';
import 'package:ziggle/app/modules/search/repository.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RootController());
    Get.lazyPut(() => HomeController(HomeRepository()));
    Get.lazyPut(() => SearchController(SearchRepository()));
  }
}
